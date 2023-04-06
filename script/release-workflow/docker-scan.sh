#!/bin/sh

set -euo >/dev/null

script_dir=$(cd "$(dirname $0)" && pwd)

for arch in amd64; do 
    ${script_dir}/../scan.sh ${DOCKER_IMAGE_ORG_AND_NAME}:latest-${arch}
done