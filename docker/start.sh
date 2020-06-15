#!/bin/sh

set -e

if [ -z $FILE_DIR ]; then
  echo >&2 "FILE_DIR is must be set"
  exit 1
fi

if [ -z $GCS_BUCKET ]; then
  echo >&2 "GCS_BUCKET is must be set"
  exit 1
fi

#if [ -z $GCP_SERVICE_ACCOUNT_KEY ]; then
#  echo >&2 "GCP_SERVICE_ACCOUNT_KEY is must be set"
#  exit 1
#fi

mkdir -p $FILE_DIR && mlflow server \
    --backend-store-uri file://${FILE_DIR} \
    --default-artifact-root gs://${GCS_BUCKET}/artifacts \
    --host 0.0.0.0 \
    --port $PORT
