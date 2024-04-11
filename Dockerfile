FROM python:3.8-alpine as base
# Installing dependencies
ENV PYTHONDONTWRITEBYTECODE 1
COPY requirements.txt /app/requirements.txt

RUN apk add --update --virtual .build-deps \
    musl-dev \
    gcc \
    && pip install -r /app/requirements.txt

# Now doing multi-stage build
FROM python:3.8-alpine

# To stop python generating .pyc files
ENV PYTHONDONTWRITEBYTECODE 1
# To stream django output to logs
ENV PYTHONUNBUFFERED 1

COPY --from=base /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages/

# Copying project
WORKDIR /usr/src/django_app
COPY . .

EXPOSE 80
