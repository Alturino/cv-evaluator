import logging
import os
import uuid
from pathlib import Path

from docling.datamodel.base_models import InputFormat
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import DocumentConverter, PdfFormatOption
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, UploadFile
from fastapi.responses import JSONResponse
from pydantic import UUID4
from sqlmodel import select
from starlette.status import (
    HTTP_400_BAD_REQUEST,
)

from baml_client.async_client import b
from baml_client.types import ProjectEvaluationResult
from model.db import SessionDep, migrations
from model.document import Document, DocumentStatus
from model.evaluation_result import Result
from model.requests.body import EvaluateRequest
from model.responses.evaluate import EvaluateResponse
from model.responses.result import ResultResponse

load_dotenv()
migrations()
pipline_options = PdfPipelineOptions(
    enable_remote_services=False,
    artifacts_path=Path.cwd().joinpath("docling_models"),
    do_ocr=False,
    generate_picture_images=False,
    generate_page_images=False,
)
doc_converter = DocumentConverter(
    allowed_formats=[InputFormat.PDF, InputFormat.DOCX, InputFormat.MD],
    format_options={InputFormat.PDF: PdfFormatOption(pipeline_options=pipline_options)},
)
logger = logging.getLogger("uvicorn.access")
logger.setLevel(logging.INFO)
app = FastAPI()


@app.post("/upload")
async def upload(
    cv: UploadFile,
    project: UploadFile,
    session: SessionDep,
):
    if not cv.filename or not project.filename:
        logger.info("file.filename", cv.filename, "file should have filename")
        raise HTTPException(
            status_code=HTTP_400_BAD_REQUEST,
            detail="file should have filename",
        )

    allowed_extension = (".txt", ".docx", ".pdf")
    if not cv.filename.endswith(allowed_extension):
        logger.info(
            f"cv_file.filename:{cv.filename},project_file.filename:{project.filename}"
        )
        raise HTTPException(
            status_code=HTTP_400_BAD_REQUEST,
            detail="only accept .txt, .docx, .pdf",
        )

    id = uuid.uuid4()
    upload_dir = os.getenv("UPLOAD_DIR")
    upload_dir = Path(upload_dir) if upload_dir else Path.cwd().joinpath("uploads")
    cv_upload_path = upload_dir.joinpath(f"{str(id)}_{cv.filename}")
    project_upload_path = upload_dir.joinpath(f"{str(id)}_{project.filename}")
    os.makedirs(name=upload_dir, exist_ok=True)

    cv_file_content = await cv.read()
    with cv_upload_path.open("+wb") as f:
        f.write(cv_file_content)

    project_file_content = await project.read()
    with project_upload_path.open("+wb") as f:
        f.write(project_file_content)

    with session as s:
        s.add(
            Document(
                id=id,
                cv_filename=cv.filename,
                cv_path=str(cv_upload_path),
                project_filename=project.filename,
                project_path=str(project_upload_path),
                status=DocumentStatus.queued,
            )
        )
        s.commit()

    return JSONResponse({"id": str(id), "status": str(DocumentStatus.queued)})


@app.post("/evaluate")
async def evaluate(req_body: EvaluateRequest, session: SessionDep) -> EvaluateResponse:
    with session as s:
        s.begin(nested=False)
        document_statement = select(Document).where(Document.id == req_body.id)
        doc_db = s.exec(document_statement).first()
        if not doc_db:
            raise HTTPException(
                status_code=HTTP_400_BAD_REQUEST,
                detail="cv file not found",
            )

        doc = doc_converter.convert(source=doc_db.cv_path).document
        cv_md = doc.export_to_markdown()
        extracted_cv = await b.ExtractCV(cv=cv_md, baml_options={})

        project_result = ProjectEvaluationResult(
            overall=0,
            correctness=0,
            code_quality=0,
            resilience=0,
            documentation=0,
            creativity_and_bonus=0,
            feedback="",
        )
        if doc_db.project_filename != "":
            project_content = Path(doc_db.project_path).read_text(encoding="utf-8")
            project_result = await b.EvaluateProject(project=project_content)

        job_desc = await b.ExtractJobDescription(job=req_body.job_description)
        overall_result = await b.EvaluateAll(
            cv=extracted_cv,
            job_description=job_desc,
            project_evaluation=project_result,
        )
        s.add(
            Result(
                id=req_body.id,
                name=f"{id}_{doc_db.cv_filename}_{doc_db.project_filename}",
                evaluation_result=overall_result,
            )
        )
        doc_db.status = DocumentStatus.finished
        s.add(doc_db)

        s.commit()
        logger.info(
            f"extracted_cv:{extracted_cv},job_description:{job_desc},project_result:{project_result},overall_result:{overall_result}"
        )

    return EvaluateResponse(id=req_body.id, status=str(DocumentStatus.queued))


@app.get("/result/{id}")
async def result(id: UUID4, session: SessionDep) -> ResultResponse:
    with session as s:
        statement = select(Result).where(Result.id == id)
        result = s.exec(statement).first()
        if not result:
            return ResultResponse(id=id, status=DocumentStatus.queued, result=None)
        return ResultResponse(
            id=id, status=DocumentStatus.finished, result=result.evaluation_result
        )
