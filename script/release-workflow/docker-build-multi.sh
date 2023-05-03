#!/bin/sh

set -euo >/dev/null

# we build images seperately, so we can load them into docker
# if running these scripts locally, or running an audit
# unfortunately, you cannot load multi-manfiest builds
# into docker, without pushing to a registry
for arch in arm64 arm amd64; do 
    docker buildx build \
    --platform linux/$arch \
    --output type=docker \
    --tag ${DOCKER_IMAGE_ORG_AND_NAME}:${TAG:-latest}-${arch} \
    .
done