#!/bin/sh

set -euo >/dev/null

for arch in arm64 arm amd64; do 
    docker buildx build \
    --platform linux/$arch \
    --output type=docker \
    --tag ${DOCKER_IMAGE_ORG_AND_NAME}:latest-${arch} \
    .
done