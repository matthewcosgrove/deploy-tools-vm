#!/usr/bin/python

import os
import subprocess
from subprocess import call
#import sys
#if sys.version_info[0] < 3:
#    raise Exception("Must be using Python 3")

MANDATORY_ENV_VARS = ["VM_HOSTNAME", "VM_USERNAME", "VM_PASSWORD",
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

# Assuming the usage of govc where this is being run so performing a conversion for all related env vars
os.environ['VCENTER_SERVER'] = os.getenv('GOVC_URL')
os.environ['VCENTER_USERNAME'] = os.getenv('GOVC_USERNAME')
os.environ['VCENTER_PASSWORD'] = os.getenv('GOVC_PASSWORD')
os.environ['VCENTER_DATASTORE'] = os.getenv('GOVC_DATASTORE')
os.environ['VCENTER_FOLDER_NAME'] = os.getenv('GOVC_FOLDER')
os.environ['VCENTER_CLUSTER'] = os.getenv('GOVC_CLUSTER')
os.environ['VCENTER_RESOURCE_POOL_NAME'] = os.getenv('GOVC_RESOURCE_POOL')
os.environ['VCENTER_NETWORK'] = os.getenv('GOVC_NETWORK')

script_dir = os.path.dirname(os.path.realpath(__file__))
packer_json_file_dir_abs_path="{}/../packer/ubuntu/".format(script_dir)
packer_json_file_name="ubuntu_1804.json"
os.environ['PACKER_JSON_FILE_DIR'] = packer_json_file_dir_abs_path
os.environ['PACKER_JSON_FILE_NAME'] = packer_json_file_name
os.environ['PACKER_CONVERT_TO_TEMPLATE'] = "true"

script_abs_path="{}/../scripts/packer_build_infra_template.sh".format(script_dir)
return_code = call(script_abs_path)

