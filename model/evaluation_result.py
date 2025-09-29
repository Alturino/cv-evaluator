from datetime import datetime

from pydantic import UUID4
from sqlmodel import JSON, Column, Field, SQLModel

from baml_client.types import OverallResult


class Result(SQLModel, table=True):
    id: UUID4 = Field(default=None, primary_key=True)
    name: str = Field(default=None, index=True)
    evaluation_result: OverallResult = Field(default=None, sa_column=Column(JSON()))
    created_at: datetime = Field(default=datetime.now(), index=True)
    updated_at: datetime = Field(default=datetime.now(), index=True)
