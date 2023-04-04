#!/bin/sh

set -eo >/dev/null


if [ -z "${TAG}" ]; then
  echo TAG env var not set
  exit 1
fi

## These will use cached builds, so wont build every time.

if [ -n "${TAG}" ]; then
  docker buildx build --platform=linux/amd64,linux/arm64,linux/arm \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:${TAG} .
fi

if [ -n "${MAJOR_TAG}" ]; then
  docker buildx build --platform=linux/amd64,linux/arm64,linux/arm \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:${MAJOR_TAG} .
fi

if [ "${PUSH_TO_LATEST}" != "false" ]; then
  docker buildx build --platform=linux/amd64,linux/arm64,linux/arm \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:latest .
fi
