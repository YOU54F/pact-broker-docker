#!/bin/sh

set -euo >/dev/null

script_dir=$(cd "$(dirname "$0")" && pwd)

# use TAG if provided
# fallback to latest
# allow to latest-$arch 
# for auditing multi_arch images
arch=${arch:-''}
if [ "${arch}" ]; then
    # strip linux/ from DOCKER_TARGET_PLATFORM linux/amd64
    echo "$arch" | sed 's/linux\///g'
    if [ "$TAG" ]; then
        TAG=${TAG}-${arch}
    else
        TAG=latest-${arch}
    fi
else
    TAG=${TAG:-latest}
fi

"${script_dir}"/../scan.sh "${DOCKER_IMAGE_ORG_AND_NAME}":"${TAG}"