#!/bin/bash
set -euo pipefail

apt update
apt install sshpass -y
ansible --version

vm_ip_address=$(cat vm-ip-address/ip.txt)

TMPDIR=""¬
TMPDIR=$(mktemp -d -t dynamic_inventory.XXXXXX)
trap 'rm -rf ${TMPDIR}' INT TERM QUIT EXIT
INVENTORY_FILE="${TMPDIR}"/inventory.yml

cat <<EOF > "${INVENTORY_FILE}"
tools:
  hosts:
    ${vm_ip_address}:
      ansible_user: ${VM_USERNAME}
      ansible_password: ${VM_PASSWORD}
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
EOF

ansible-inventory -i "${INVENTORY_FILE}" --list

ansible -i "${INVENTORY_FILE}" -m ping tools

# ansible-playbook -vvv -i "${INVENTORY_FILE}" ubuntu-ansible-playbook/ansible/ubuntu/playbook.yml

