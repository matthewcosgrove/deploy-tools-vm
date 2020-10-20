#!/bin/bash
set -euo pipefail


export VM_IP_ADDRESS=$(cat vm-ip-address/ip.txt)
export INPUT_PLAYBOOK_DIR="ubuntu-ansible-playbook/ansible/ubuntu/"
export REQUIREMENTS_YAML="${INPUT_PLAYBOOK_DIR}/requirements.yml"
export PLAYBOOK_YAML="${INPUT_PLAYBOOK_DIR}/playbook.yml"
export ANSIBLE_FORCE_COLOR='1'
./concourse-tasks/scripts/run_ansible_playbook.sh
