#!/bin/bash
set -euo pipefail
: "${PACKER_JSON_FILE_DIR:? PACKER_JSON_FILE_DIR must be set to the absolute path for the directory containing the packer json file }"
: "${PACKER_JSON_FILE_NAME:? PACKER_JSON_FILE_NAME must be set to the name of the packer json file }"

PACKER_JSON_ABSOLUTE_FILEPATH="${PACKER_JSON_FILE_DIR}"/"${PACKER_JSON_FILE_NAME}"
echo "Running packer build with template ${PACKER_JSON_ABSOLUTE_FILEPATH}"
echo "Will be deployed to vcenter as ${VM_HOSTNAME} with username ${VM_USERNAME}"
packer version
TMPDIR=""¬
TMPDIR=$(mktemp -d -t dynamic_vars.XXXXXX)
trap 'rm -rf ${TMPDIR}' INT TERM QUIT EXIT
VARS_FILE="${TMPDIR}"/variables.json

cat <<EOF > "${VARS_FILE}"
{
    "convert_to_template":"${PACKER_CONVERT_TO_TEMPLATE}",
    "vcenter_server":"${VCENTER_SERVER}",
    "vcenter_username":"${VCENTER_USERNAME}",
    "vcenter_password":"${VCENTER_PASSWORD}",
    "vcenter_datastore":"${VCENTER_DATASTORE}",
    "vcenter_folder": "${VCENTER_FOLDER_NAME}",
    "vcenter_cluster": "${VCENTER_CLUSTER}",
    "vcenter_resource_pool":"${VCENTER_RESOURCE_POOL_NAME}",
    "vcenter_network": "${VCENTER_NETWORK}",
    "vm_hostname": "${VM_HOSTNAME}",
    "vm_username": "${VM_USERNAME}",
    "vm_password": "${VM_PASSWORD}"
}
EOF
cat "${VARS_FILE}" | grep -v password

pushd "${PACKER_JSON_FILE_DIR}" # Needed for relative paths to Ansible playbooks etc
echo "Executing packer commands.."
packer inspect "${PACKER_JSON_ABSOLUTE_FILEPATH}"
packer validate -var-file "${VARS_FILE}" "${PACKER_JSON_ABSOLUTE_FILEPATH}"
packer build -var-file "${VARS_FILE}" "${PACKER_JSON_ABSOLUTE_FILEPATH}"
popd
