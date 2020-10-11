#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

package="minio-client"
cli="mc"
if ! hash "${cli}" >/dev/null 2>&1; then
    echo "Installing ${package}..."
    sudo wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
    sudo chmod +x /usr/local/bin/mc
else
    echo "${package} already installed, skipping.."
fi
