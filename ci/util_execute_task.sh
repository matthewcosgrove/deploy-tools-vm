#!/bin/bash
# https://medium.com/@andrew_merrell/concourses-fly-execute-is-a-hidden-gem-5f4b54ffb249
# https://stackoverflow.com/questions/44808892/in-concourse-how-do-you-hijack-a-container-made-via-fly-execute

set -eu
REPO_ROOT_DIR="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )")"
TASKS_PARENT_DIR_NAME=${TASKS_PARENT_DIR_NAME:=ci}
fly_target=$1
fly_task_dirs=$2
echo "IMPORTANT: Using \"job-name/task-name\" specified as second arg (check the format is correct). You entered: $2"
shift
shift
set -x
fly -t "${fly_target}" e -c "${REPO_ROOT_DIR}"/"${TASKS_PARENT_DIR_NAME}"/tasks/"${fly_task_dirs}"/task.yml \
	--input="concourse-tasks=${REPO_ROOT_DIR}" \
	"$@"
set +x
