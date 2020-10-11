#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir="/home/ubuntu/.fzf"
if [[ ! -d "${dir}" ]];then
   # https://github.com/junegunn/fzf#using-git
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install --key-bindings --completion --update-rc
else
   echo "${dir} exists, skipping install of FZF..."
fi
