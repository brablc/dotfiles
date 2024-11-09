#!/usr/bin/env bash

brew tap hashicorp/tap
brew install azure-cli kubernetes-cli node python@3.10 teleport terraform terramate hashicorp/tap/vault

for COMMAND in az kubectl; do
  ln -s ${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/$COMMAND ${HOME}/.local/share/bash-completion/completions/
done

python3.12 -m venv $HOME/.local/share/nvim-venv
source $HOME/.local/share/nvim-venv/bin/activate
pip install tree-sitter-make==0.0.1
pip install lsp-tree-sitter
pip install autotools-language-server==0.0.21
deactivate
