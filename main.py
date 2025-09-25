import base64
import logging
import os
import uuid
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, UploadFile
from fastapi.responses import JSONResponse
from starlette.status import (
    HTTP_400_BAD_REQUEST,
)

from model.db import SessionDep, migrations
from model.document import Document, DocumentStatus

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
