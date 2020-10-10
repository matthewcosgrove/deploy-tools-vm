#!/bin/bash

set -euo pipefail

: "${FLY_TARGET:? FLY_TARGET must be set }"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

task_identifier="ubuntu-day-one/run-ansible-playbook"
input_ansible_playbook="--input=ubuntu-ansible-playbook=${SCRIPT_DIR}/.."
input_vm_ip_address="--input=vm-ip-address=${SCRIPT_DIR}/../../test-helpers/vm-ip-address"
"$SCRIPT_DIR/../ci/util_execute_task.sh" "$FLY_TARGET" "${task_identifier}" \
	"${input_ansible_playbook}" \
	"${input_vm_ip_address}" \
	-v ubuntu_vm_username="ubuntu"
