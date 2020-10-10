#!/bin/bash
set -euo pipefail

if [ ${#VM_PASSWORD} -le 7 ]; then 
  echo "Error password should be 8 chars or more"
  exit 1
fi

abs_path="$(pwd)"
export PACKER_JSON_FILE_DIR="${abs_path}/${PACKER_FILE_INPUT_ALIAS_DIR}/${PACKER_FILE_RELATIVE_PATH_DIR}"
pushd "${PACKER_FILE_INPUT_ALIAS_DIR}" > /dev/null
commit_sha=$(git rev-parse --short=8 HEAD) # --short=8 to match gitlab convention
echo "Commit SHA = ${commit_sha}"
popd > /dev/null
export VM_HOSTNAME="${VM_HOSTNAME}"-"${commit_sha}"
echo "Ensuring uniqueness of template name with commit sha suffix. VM_HOSTNAME="${VM_HOSTNAME}""
if [[ $(govc vm.info "${VM_HOSTNAME}") ]]; then
    echo "VM ${VM_HOSTNAME} already exists. Skipping.."
    exit 0
else
    echo "no VM ${VM_HOSTNAME} found. Proceeding.."
fi
./concourse-tasks/ci/tasks/scripts/packer_build_infra_template.sh
