#!/usr/bin/python

import os
import subprocess
from subprocess import call

MANDATORY_ENV_VARS = ["VM_HOSTNAME",
        "GOVC_URL", "GOVC_USERNAME", "GOVC_PASSWORD", 
        "GOVC_DATASTORE", "GOVC_FOLDER", "GOVC_CLUSTER", 
        "GOVC_RESOURCE_POOL", "GOVC_NETWORK"]

isMandatoryVarMissing = False
for var in MANDATORY_ENV_VARS:
    if var not in os.environ:
        isMandatoryVarMissing = True
        print("Mandatory env var {} is not set".format(var))
if isMandatoryVarMissing:
    raise EnvironmentError("Failed because mandatory env vars not set. See output further above for details")

for env_var in os.environ:
    if env_var.startswith("GOVC_") and "PASSWORD" not in env_var:
        print(env_var + "=" + os.getenv(env_var))

# TODO: Sort this out properly..
os.environ['VM_TEMPLATE_HOSTNAME'] = os.getenv('VM_HOSTNAME')
os.environ['VM_HOSTNAME'] = os.getenv('VM_TEMPLATE_HOSTNAME') + "-from-template"

script_dir = os.path.dirname(os.path.realpath(__file__))
script_abs_path="{}/../scripts/clone_from_template.sh".format(script_dir)
return_code = call(script_abs_path)

