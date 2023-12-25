#!/usr/bin/env bash
set -euo pipefail
[[ -n "${TRACE:-}" ]] && set -x
DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

main() {
  echo "update-content begin"
  echo "$(date +'%Y-%m-%d %H:%M:%S')    update-content begin" >> "$HOME/status"

  echo 'initializing submodules'
  git submodule update --init --recursive

  echo 'linking repo to $GOPATH'
  mkdir -p /go/src/github.com/argoproj
  ln -sf "$PWD"/argo-cd /go/src/github.com/argoproj/argo-cd

  echo 'initializing Argo CD toolchain'
  cd argo-cd
  make install-tools-local
  make mod-download-local
  make mod-vendor-local

  echo 'running codegen'
  cd /go/src/github.com/argoproj/argo-cd
  make codegen-local

  echo "update-content end"
  echo "$(date +'%Y-%m-%d %H:%M:%S')    update-content end" >> "$HOME/status"
}

main "$@"
