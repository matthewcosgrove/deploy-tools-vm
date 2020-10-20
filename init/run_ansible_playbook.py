#!/usr/bin/python

import os
import subprocess
from subprocess import call

MANDATORY_ENV_VARS = ["VM_IP_ADDRESS",
        "VM_USERNAME", "VM_PASSWORD", 
        "GIT_CONFIG_USERNAME", "GIT_CONFIG_EMAIL"]

is_mandatory_var_missing = False
for var in MANDATORY_ENV_VARS:
    if var not in os.environ:
        is_mandatory_var_missing = True
        print("Mandatory env var {} is not set".format(var))
if is_mandatory_var_missing:
    raise EnvironmentError("Failed because mandatory env vars not set. See output further above for details")

for env_var in os.environ:
    if env_var.startswith("VM_") and "PASSWORD" not in env_var:
        print(env_var + "=" + os.getenv(env_var))
    if env_var.startswith("GIT_CONFIG_"):
        print(env_var + "=" + os.getenv(env_var))

script_dir = os.path.dirname(os.path.realpath(__file__))
ansible_yaml_dir = "{}/../ansible/ubuntu".format(script_dir)
os.environ['REQUIREMENTS_YAML'] = "{}/requirements.yml".format(ansible_yaml_dir)
os.environ['PLAYBOOK_YAML'] = "{}/playbook.yml".format(ansible_yaml_dir) 
script_abs_path="{}/../scripts/run_ansible_playbook.sh".format(script_dir)
return_code = call(script_abs_path)

