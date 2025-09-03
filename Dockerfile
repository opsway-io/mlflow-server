FROM python:3.10.18-slim AS runtime

WORKDIR /app

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    POETRY_HOME=/app/poetry

COPY ./pyproject.toml ./poetry.lock /

RUN pip install poetry==2.1.2

RUN poetry install --no-root && rm -rf $POETRY_CACHE_DIR

ENTRYPOINT GUNICORN_CMD_ARGS="--timeout 600" mlflow server --backend-store-uri postgresql+psycopg2://${DB_USERNAME}:${DB_PASSWORD}@${DB_URL}/${DB_NAME} --artifacts-destination ${ARTIFACT_STORE} --serve-artifacts --host 0.0.0.0 --port 5000