from pydantic import UUID4, BaseModel


class EvaluateRequest(BaseModel):
    id: UUID4
    job_description: str
