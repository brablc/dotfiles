#!/usr/bin/env bash

brew install azure-cli kubernetes-cli node python@3.10 teleport terraform terramate

for COMMAND in az kubectl; do
  ln -s ${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/$COMMAND ${HOME}/.local/share/bash-completion/completions/
done
