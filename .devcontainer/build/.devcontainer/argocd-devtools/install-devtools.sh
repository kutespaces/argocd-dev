#!/usr/bin/env bash
set -euo pipefail
[[ -n "${TRACE:-}" ]] && set -x
DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

main() {
  echo "activating asdf"
  . ~/.asdf/asdf.sh

  echo "installing golang"
  asdf plugin add golang
  asdf install golang 1.21.5
  asdf global golang 1.21.5

  echo "setting up shell"
  echo "alias k=kubectl" >> ~/.zshrc
  echo "alias kns=kubens" >> ~/.zshrc
  echo "alias kcx=kubectx" >> ~/.zshrc
  echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.zshrc

  # Tells 'less' not to paginate if less than a page
  echo 'export LESS="-F -X $LESS"' >> ~/.zshrc
  printf '[alias]\n  please = push --force-with-lease\n' >> ~/.gitconfig
  git config --global pull.ff only
}

if [[ $EUID -ne 1000 ]];
then
    exec sudo -i -u vscode /bin/bash "$0" "$@"
fi

main "$@"
