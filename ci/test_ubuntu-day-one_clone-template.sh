#!/bin/bash

set -euo pipefail

: "${FLY_TARGET:? FLY_TARGET must be set }"
: "${VMWARE_TEMPLATE_NAME:? VMWARE_TEMPLATE_NAME must be set to one that pre-exists in vcenter }"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

unset GOVC_RESOURCE_POOL GOVC_NETWORK
required_template_name="${VMWARE_TEMPLATE_NAME}"
echo "Expected template to use is ${required_template_name}. Checking it exists.."
out=$(govc vm.info ${required_template_name})
if [ -z "${out}" ];then
  echo "Required template not available, skipping test.."
  exit 0
fi

# Override the values in task.yml
export VM_TEMPLATE_HOSTNAME="${required_template_name}"
export VM_HOSTNAME="local-test-${required_template_name}"
export USE_COMMIT_SHA_FOR_VM_NAME_SUFFIX="false"

task_identifier="ubuntu-day-one/clone-template"
input_commit_sha_repo="--input=ubuntu-template-packer-build-config=${SCRIPT_DIR}/.."
"$SCRIPT_DIR/../ci/util_execute_task.sh" "$FLY_TARGET" "${task_identifier}" \
	"${input_commit_sha_repo}" \
	-v ubuntu_vm_username="ubuntu" \
        --include-ignored # Needed for including the .git folder

#"$SCRIPT_DIR/../ci/util_execute_task.sh" "$FLY_TARGET" ubuntu-day-one/teardown-vm \
#	"${input_commit_sha_repo}" \
#       --include-ignored # Needed for including the .git folder
