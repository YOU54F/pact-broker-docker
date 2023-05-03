#!/bin/sh

set -euo >/dev/null

workflow_dir=$(cd "$(dirname $0)" && pwd)

if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
  ${workflow_dir}/git-configure.sh
  ${workflow_dir}/docker-login.sh
fi

. ${workflow_dir}/set-env-vars.sh

${script_dir}/validate.sh
${script_dir}/docker-prepare.sh
${script_dir}/docker-build-multi.sh
arch=amd64 ${script_dir}/docker-scan.sh
${script_dir}/prepare-release.sh
${script_dir}/docker-push.sh
${script_dir}/git-push.sh
