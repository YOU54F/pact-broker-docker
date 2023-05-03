#!/bin/sh

set -euo >/dev/null


if [ -z "${TAG}" ]; then
  echo TAG env var not set
  exit 1
fi

PUSH_TO_LATEST=${PUSH_TO_LATEST:-"false"}

push_multi() {
## These will use cached builds, so wont build every time.
  docker buildx build --platform=linux/amd64,linux/arm64,linux/arm \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:$1-multi .
}

if [ -n "${TAG}" ]; then
  docker buildx build --platform=linux/amd64 \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:${TAG} .

 ## We will temporarily publish a multi manifest built as $TAG-multi
 ## To avoid any issues with existing users. We can ask users for 
 ## Feedback and then promote to a multi-manifest build
  push_multi ${MAJOR_TAG}
fi

if [ -n "${MAJOR_TAG}" ]; then
  docker buildx build --platform=linux/amd64 \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:${MAJOR_TAG} .
  push_multi ${MAJOR_TAG}
fi

if [ "${PUSH_TO_LATEST}" != "false" ]; then
  docker buildx build --platform=linux/amd64 \
    --output=type=image,push=true \
    -t ${DOCKER_IMAGE_ORG_AND_NAME}:latest .
  push_multi latest
fi