#!/usr/bin/env bash
set -euo pipefail
[[ -n "${TRACE:-}" ]] && set -x
DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

main() {
  gpasswd -a vscode docker

  echo "adding helm apt repo"
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

  echo "installing make & helm"
  apt-get update
  apt-get -y install make helm gpg git-lfs

  echo "installing user devtools"
  "$DIR"/install-devtools.sh
}

main "$@"
