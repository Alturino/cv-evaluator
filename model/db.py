import os
from typing import Annotated
from dotenv import load_dotenv
from sqlalchemy.engine import URL, Engine
from sqlmodel import SQLModel, Session, create_engine
from fastapi import Depends

load_dotenv()

engine = create_engine(
    url=URL.create(
        drivername="postgresql",
        username=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host="localhost",
        port=int(os.getenv("POSTGRES_PORT")),
        database=os.getenv("POSTGRES_DATABASE"),
        query={"sslmode": "disable"},
    ),
    echo=True,
    connect_args={},
)


def get_session():
    with Session(engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]


def migrations(engine: Engine = engine):
    SQLModel.metadata.create_all(engine)
