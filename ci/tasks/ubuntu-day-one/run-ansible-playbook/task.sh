#!/bin/bash
set -euo pipefail


export VM_IP_ADDRESS=$(cat vm-ip-address/ip.txt)
export INPUT_PLAYBOOK_DIR="ubuntu-ansible-playbook/ansible/ubuntu/"
export REQUIREMENTS_YAML="${INPUT_PLAYBOOK_DIR}/requirements.yml"
export PLAYBOOK_YAML="${INPUT_PLAYBOOK_DIR}/playbook.yml"

TMPDIR=""¬
TMPDIR=$(mktemp -d -t dynamic_inventory.XXXXXX)
trap 'rm -rf ${TMPDIR}' INT TERM QUIT EXIT
INVENTORY_FILE="${TMPDIR}"/inventory.yml

cat <<EOF > "${INVENTORY_FILE}"
tools:
  hosts:
    ${VM_IP_ADDRESS}:
      ansible_user: "${VM_USERNAME}"
      ansible_password: "${VM_PASSWORD}"
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
      git_config_username: "${GIT_CONFIG_USERNAME}"
      git_config_email: "${GIT_CONFIG_EMAIL}"
EOF

ansible --version
ansible-inventory -i "${INVENTORY_FILE}" --list

ansible -i "${INVENTORY_FILE}" -m ping tools

ansible-galaxy collection install matthewcosgrove.tools_vm
ansible-galaxy install -r "${REQUIREMENTS_YAML}"
ansible-playbook -i "${INVENTORY_FILE}" "${PLAYBOOK_YAML}"
