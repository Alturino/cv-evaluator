import enum
from datetime import datetime

from pydantic import UUID4
from sqlmodel import Column, Enum, Field, SQLModel


class DocumentStatus(enum.Enum):
    queued = "queued"
    finished = "finished"


class Document(SQLModel, table=True):
    id: UUID4 = Field(default=None, primary_key=True)
    cv_filename: str = Field(default=None, index=True)
    cv_path: str = Field(default=None, index=False)
    project_filename: str = Field(default=None, index=True)
    project_path: str = Field(default=None, index=False)
    status: DocumentStatus = Field(
        default=DocumentStatus.queued, sa_column=Column(Enum(DocumentStatus))
    )
    created_at: datetime = Field(default=datetime.now(), index=True)
    updated_at: datetime = Field(default=datetime.now(), index=True)
