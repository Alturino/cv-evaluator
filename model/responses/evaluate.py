from pydantic import UUID4, BaseModel


class EvaluateResponse(BaseModel):
    id: UUID4
    status: str
