from pydantic import UUID4, BaseModel

from baml_client.types import OverallResult
from model.document import DocumentStatus


class ResultResponse(BaseModel):
    id: UUID4
    status: DocumentStatus
    result: OverallResult | None
