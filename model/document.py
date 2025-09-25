import enum
from datetime import datetime

from pydantic import UUID4, Base64Bytes
from sqlmodel import Column, Enum, Field, SQLModel


class DocumentStatus(enum.Enum):
    queued = "queued"
    processing = "processing"
    finished = "finished"


class Document(SQLModel, table=True):
    id: UUID4 = Field(default=None, primary_key=True)
    name: str = Field(default=None, index=True)
    content: Base64Bytes = Field(default=None, index=False)
    path: str = Field(default=None, index=False)
    status: DocumentStatus = Field(
        default=DocumentStatus.queued, sa_column=Column(Enum(DocumentStatus))
    )
    created_at: datetime = Field(default=datetime.now(), index=True)
    updated_at: datetime = Field(default=datetime.now(), index=True)
