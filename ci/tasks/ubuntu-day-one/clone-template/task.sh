#!/bin/bash
set -euo pipefail

if "${USE_COMMIT_SHA_FOR_VM_NAME_SUFFIX}";then
  pushd ubuntu-template-packer-build-config > /dev/null
  commit_sha=$(git rev-parse --short=8 HEAD) # --short=8 to match gitlab convention
  echo "Commit SHA = ${commit_sha}"
  popd > /dev/null
  export VM_TEMPLATE_HOSTNAME="${VM_TEMPLATE_HOSTNAME}"-"${commit_sha}"
  export VM_HOSTNAME="${VM_HOSTNAME}"-"${commit_sha}"
fi
./concourse-tasks/ci/tasks/scripts/clone_from_template.sh
echo "Retrieving IP address of VM $VM_HOSTNAME for next task"
vm_ip_address=$(govc vm.ip $VM_HOSTNAME)
cat <<EOF > vm-ip-address/ip.txt
${vm_ip_address}
EOF
