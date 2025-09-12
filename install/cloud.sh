#!/usr/bin/env bash

# Installations

brew install \
  cdebug \
  conftest \
  cosign \
  editorconfig-checker \
  hcl2json \
  helm \
  kubeconform \
  kustomize \
  lazysql \
  node \
  oras \
  python@3.10 \
  python@3.11 \
  python@3.12 \
  temporal \
  terraform-docs \
  tflint \
  yq \
  vcluster

KUBECTL_VERSION=v1.32
TARGETARCH=$(dpkg --print-architecture)

sudo mkdir -m 755 -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [arch=${TARGETARCH} signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBECTL_VERSION/deb/ /" | sudo sponge /etc/apt/sources.list.d/kubernetes.list
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=${TARGETARCH} signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ noble main" | sudo sponge /etc/apt/sources.list.d/azure-cli.list
curl -sLS https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=${TARGETARCH} signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | sudo sponge /etc/apt/sources.list.d/hashicorp.list
# echo "deb [trusted=yes] https://repo.terramate.io/apt/ /" | sudo tee /etc/apt/sources.list.d/terramate.list

# APT install including prepared
sudo chmod -c a+r /etc/apt/keyrings/*       # allow unprivileged APT programs to read this keyring
sudo chmod -c a+r /etc/apt/sources.list.d/* # helps tools such as command-not-found to work correctly
sudo apt-get update
sudo apt-get install \
  azure-cli \
  kubectl \
  oathtool \
  packer \
  terraform \
  terraform-switcher \
  vault

## prepare azcopy
# curl -sLSO https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
# sudo dpkg -i ./packages-microsoft-prod.deb
# rm -f ./packages-microsoft-prod.deb

## install flux
curl -fsSL https://github.com/fluxcd/flux2/releases/download/v2.6.2/flux_2.6.2_linux_amd64.tar.gz | tar xzf - -C "$HOME/.local/bin/"

# install terramate
TERRAMATE_VERSION="0.13.0"
TERRAMATE_ARCHIVE="terramate_${TERRAMATE_VERSION}_linux_x86_64.tar.gz"
curl -L "https://github.com/terramate-io/terramate/releases/download/v${TERRAMATE_VERSION}/${TERRAMATE_ARCHIVE}" | tar xz -C "$HOME/.local/bin" terramate

# configure tflint
tflint --init

npm install -g pajv # required by gitops

# Completions

BASH_CMPL_DIR=.local/share/bash-completion/completions

for COMMAND in conftest flux helm kustomize vcluster temporal; do
  ln -s "${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

for COMMAND in globalprotect terraform; do
  ln -s "${HOME}/.local/share/dotfiles/home/.local/share/${BASH_CMPL_DIR}/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

ln -s "$HOME/$BASH_CMPL_DIR/globalprotect" "$HOME/$BASH_CMPL_DIR/gp"

flux completion bash >"$HOME/$BASH_CMPL_DIR/flux"
kubectl completion bash | tee "$HOME/$BASH_CMPL_DIR"/{kubectl,k} >/dev/null
echo "complete -o default -F __start_kubectl k" >>"$HOME/$BASH_CMPL_DIR"/k
tsh --completion-script-bash >"$HOME/$BASH_CMPL_DIR/tsh"
echo "complete -C $HOME/.local/bin/terramate terramate" >>"$HOME/$BASH_CMPL_DIR/terramate"
tsh --completion-script-bash >"$HOME/$BASH_CMPL_DIR/tsh"
tctl --completion-script-bash >"$HOME/$BASH_CMPL_DIR/tctl"
echo "complete -C /usr/bin/vault vault" >"$HOME/$BASH_CMPL_DIR/vault"

# Docker domain name resolution
HOST_DOCKER_INTERNAL=$(ip -j addr show docker0 | jq -r .[0].addr_info.[0].local)
echo -e "[Resolve]\nDNSStubListenerExtra=$HOST_DOCKER_INTERNAL" | sudo tee /etc/systemd/resolved.conf.d/docker.conf
sudo systemctl restart systemd-resolved.service
jq --arg ip "$HOST_DOCKER_INTERNAL" '. + {dns:[$ip]}' /etc/docker/daemon.json | sponge | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker.service
