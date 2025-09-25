FROM python:3.13.7-alpine
RUN apk update && apk add --no-cache git

LABEL authors="Ricky Alturino"

WORKDIR /usr/app/evaluator/

ENV FASTAPI_PORT="80" FASTAPI_HOST="0.0.0.0" FASTAPI_WORKERS=4

RUN pip install --no-cache-dir uv
COPY ["uv.lock", "pyproject.toml", './' ]

RUN uv sync --frozen --no-cache

COPY ["main.py", "baml_client/", "model/", "log_conf.yaml", "./"]
CMD [ "uv", "run", "fastapi", "run", "main.py", "--port", $FASTAPI_PORT, "--host", $FASTAPI_HOST, '--workers', $FASTAPI_WORKERS, '--log-config', 'log_conf.yaml']
