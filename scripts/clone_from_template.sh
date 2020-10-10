#!/bin/bash
set -euo pipefail

env | grep GOVC_ | grep -i -v password
env | grep VM_ | grep -i -v password
template_path="${GOVC_FOLDER}"/"${VM_TEMPLATE_HOSTNAME}"
new_vm_path="${GOVC_FOLDER}"/"${VM_HOSTNAME}"
echo "Preparing to create VM ${new_vm_path} from template ${template_path} via govc"
echo "Info for ${template_path}"
govc vm.info "${template_path}"
govc vm.clone -h # check the defaults via the env vars are populated
govc vm.clone -waitip=true -vm "${VM_TEMPLATE_HOSTNAME}" "${VM_HOSTNAME}"
# govc vm.clone -vm "${VM_TEMPLATE_HOSTNAME}" -customization="MyVCenterCustomization" "${VM_HOSTNAME}"
# For reference, if we need dynamic set up we can use..
# govc vm.customize -vm "${VM_HOSTNAME}" MyVCenterCustomization
govc vm.info "${VM_HOSTNAME}"
echo "VM is ready to login with ssh ubuntu@$(govc vm.ip ${VM_HOSTNAME})"
