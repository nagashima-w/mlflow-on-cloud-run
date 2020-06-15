FROM python:3.8-slim

RUN pip install mlflow==1.8.0

ENV PORT 5000
ENV FILE_DIR
ENV GCS_BUCKET

COPY start.sh /

ENTRYPOINT ["/start.sh"]