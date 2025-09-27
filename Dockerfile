FROM python:3.13.7-alpine
RUN apk update && apk add --no-cache git

LABEL authors="Ricky Alturino"

WORKDIR /usr/app/evaluator/

ENV FASTAPI_PORT="80" FASTAPI_HOST="0.0.0.0"

RUN pip install --no-cache-dir uv
COPY ["uv.lock", "pyproject.toml", "main.py", "./baml_client/", "./"]

RUN uv sync --frozen --no-cache
CMD [ "./.venv/bin/fastapi", "run", "main.py", "--port", $FASTAPI_PORT, "--host", $FASTAPI_HOST ]
