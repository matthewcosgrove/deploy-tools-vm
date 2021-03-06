Tools VM deployed via Packer onto vcenter provisioned with Ansible

## Chicken And Egg

There are pipelines to rollout this Tools VM via Concourse. See [ci](ci).

However, you are likely to need a Tools VM first before you can [rollout Concourse on vcenter](https://github.com/matthewcosgrove/lab-ops) 

So, for the first time, from a location that can run python scripts, bash scripts, reach vcenter, and that has govc, packer and ansible installed, run the following

NOTE: You will need to set the appropriate environment variables for each script

```
./init/packer_build_infra_template.py
./init/clone_from_template.py
./init/run_ansible_playbook.py
```

Optional: You can provide your own packer file by overriding the env vars `PACKER_JSON_FILE_DIR` and `PACKER_JSON_FILE_NAME` (this may be useful if you need to add a custom ca cert etc)
