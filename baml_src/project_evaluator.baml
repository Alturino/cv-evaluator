class ProjectEvaluationResult {
    overall float
    correctness float
    code_quality float
    resilience float
    documentation float
    creativity_and_bonus float
    feedback string
}

function EvaluateProject(project: string) -> ProjectEvaluationResult {
    client CustomGemini
    prompt #"
        You are an expert technical reviewer evaluating a project submission.

        Project Source File Content:
        {{ project }}

        Please evaluate this project based on the following criteria (1-5 scale each):
        1. Correctness (25% weight): meets requirements, prompt design, LLM chaining, RAG, error handling
        2. Code Quality (20% weight): clean, modular, testable, best practices
        3. Resilience (20% weight): handles failures, retries, monitoring, graceful degradation
        4. Documentation (15% weight): clear README, API docs, architecture decisions, trade-offs
        5. Creativity/Bonus (20% weight): additional features, performance optimization, security, deployment

        Provide an overall score out of 10 and detailed feedback.
        {{ ctx.output_format }}
    "#
}


test evaluate_project {
  functions [EvaluateProject]
  args {
         project #"
            ```python
                import base64
                import logging
                import os
                import uuid
                from pathlib import Path

                from docling.datamodel.base_models import InputFormat
                from docling.document_converter import DocumentConverter
                from dotenv import load_dotenv
                from fastapi import FastAPI, HTTPException, UploadFile
                from fastapi.responses import JSONResponse
                from sqlmodel import select
                from starlette.status import (
                    HTTP_400_BAD_REQUEST,
                )

                from model.db import SessionDep, migrations
                from model.document import Document, DocumentStatus
                from model.requests.body import EvaluateRequest

                MAX_REQUEST_SIZE = 2 * 1024 * 1024


                load_dotenv()
                logger = logging.getLogger("uvicorn.access")
                logger.setLevel(logging.INFO)
                migrations()
                app = FastAPI()


                @app.post("/upload")
                async def upload(
                    file: UploadFile,
                    session: SessionDep,
                ):
                    if not file.filename:
                        logger.info("file.filename", file.filename, "file should have filename")
                        raise HTTPException(
                            status_code=HTTP_400_BAD_REQUEST,
                            detail="file should have filename",
                        )

                    allowed_extension = (".txt", ".docx", ".pdf")
                    if not file.filename.endswith(allowed_extension):
                        logger.info("file.filename", file.filename)
                        raise HTTPException(
                            status_code=HTTP_400_BAD_REQUEST,
                            detail="only accept .txt, .docx, .pdf",
                        )

                    id = uuid.uuid4()
                    upload_dir = os.getenv("UPLOAD_DIR")
                    upload_dir = Path(upload_dir) if upload_dir else Path.cwd().joinpath("uploads")
                    upload_path = upload_dir.joinpath(f"{str(id)}_{file.filename}")
                    os.makedirs(name=upload_dir, exist_ok=True)

                    file_content = await file.read()
                    b64_encoded = base64.b64encode(file_content)
                    with upload_path.open("wb") as f:
                        f.write(file_content)

                    with session as s:
                        s.add(
                            Document(
                                id=id,
                                name=file.filename,
                                content=b64_encoded,
                                path=str(upload_path),
                                status=DocumentStatus.queued,
                            )
                        )
                        s.commit()

                    return JSONResponse({"id": str(id), "status": str(DocumentStatus.queued)})


                @app.post("/evaluate")
                async def evaluate(req_body: EvaluateRequest, session: SessionDep) -> JSONResponse:
                    with session as s:
                        statement = (
                            select(Document)
                            .where(Document.name == req_body.cv_file)
                            .where(Document.id == req_body.id)
                        )
                        cv = s.exec(statement).first()
                        if not cv:
                            raise HTTPException(
                                status_code=HTTP_400_BAD_REQUEST,
                                detail="cv file not found",
                            )

                        statement = (
                            select(Document)
                            .where(Document.name == req_body.project_file)
                            .where(Document.id == req_body.id)
                        )
                        project = s.exec(statement).first()
                        file_paths = [cv.path, project.path] if project else [cv.path]

                        doc_converter = DocumentConverter(
                            allowed_formats=[InputFormat.PDF, InputFormat.DOCX, InputFormat.MD],
                        )
                        for path in file_paths:
                            conv_res = doc_converter.convert(path)

                    return JSONResponse({"status": "ok", "message": "ok"})
            ```
         "# 
  }
}
