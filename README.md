Tools VM deployed via Packer onto vcenter provisioned with Ansible

## Chicken And Egg

There are pipelines to rollout this Tools VM via Concourse. See [ci](ci).

However, you are likely to need a Tools VM first before you can [rollout Concourse on vcenter](https://github.com/matthewcosgrove/lab-ops) 

So, for the first time, from a location that can run bash scripts, reach vcenter, and that has packer and govc installed, run the following 

NOTE: You will need to set the appropriate environment variables for each script

```
./scripts/packer_build_infra_template.sh
./scripts/clone_from_template.sh
```
