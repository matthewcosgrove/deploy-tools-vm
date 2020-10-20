#!/bin/bash
set -euo pipefail

echo "Info for folder: ${GOVC_FOLDER}"
govc folder.info "${GOVC_FOLDER}"
echo "Info for datastore: ${GOVC_DATASTORE}"
govc datastore.info "${GOVC_DATASTORE}"
echo "Info for resource pool: ${GOVC_RESOURCE_POOL}"
govc pool.info "${GOVC_RESOURCE_POOL}"
template_path="${GOVC_FOLDER}"/"${VM_HOSTNAME}"
echo "Info for VM Template ${template_path}"
govc vm.info "${template_path}"
