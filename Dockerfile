FROM python:3.13.7-slim-trixie
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN apt update -y && apt upgrade -y && apt install git -y

LABEL authors="Ricky Alturino"

WORKDIR /usr/app/evaluator/

ENV FASTAPI_PORT="80"
ENV FASTAPI_HOST="0.0.0.0"
ENV FASTAPI_WORKERS=4

COPY ["uv.lock", "pyproject.toml", "./" ]
RUN uv sync --locked --no-cache

COPY ["main.py", "baml_client/", "model/", "uploads/", "docling_models/", "log_conf.yaml", "./"]

CMD [ "uv", "run", "fastapi", "run", "main.py", "--port", $FASTAPI_PORT, "--host", $FASTAPI_HOST, '--workers', $FASTAPI_WORKERS, '--log-config', 'log_conf.yaml']
