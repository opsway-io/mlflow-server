FROM python:3.10.9-slim as build

COPY ./pyproject.toml ./poetry.lock /

RUN pip install poetry

RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.10.9-slim as runtime

COPY --from=build requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

ENTRYPOINT GUNICORN_CMD_ARGS="--timeout 600" mlflow server --backend-store-uri postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_URL}/${DB_NAME} --artifacts-destination ${ARTIFACT_STORE} --serve-artifacts --host 0.0.0.0

