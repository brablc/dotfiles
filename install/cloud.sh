#!/usr/bin/env bash

# Installations

brew tap hashicorp/tap
brew install \
  yq \
  node \
  python@3.10 \
  python@3.11 \
  python@3.12 \
  conftest \
  cosign \
  fluxcd/tap/flux \
  helm \
  kustomize \
  oras \
  terraform-docs \
  tflint \
  hashicorp/tap/vault \
  vcluster

sudo mkdir -p /etc/apt/keyrings

## teleport
# - https://purestorage-saas.teleport.sh/web/downloads
# - https://cdn.teleport.dev/teleport-ent_16.4.9_amd64.deb

## prepare azure-cli
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg >/dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources

## azd

curl -fsSLO https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_1.11.1/azd_1.11.1_amd64.deb
sudo apt-get install ./azd_1.11.1_amd64.deb -y

## prepare azcopy
curl -sLSO https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
sudo dpkg -i ./packages-microsoft-prod.deb
rm -f ./packages-microsoft-prod.deb

# prepare kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list # helps tools such as command-not-found to work correctly

# prepare terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# install
sudo apt-get update
sudo apt-get install azure-cli azcopy kubectl expect terraform=1.10.4-\* packer powershell

# install terramate
TERRAMATE_VERSION="0.11.4"
TERRAMATE_ARCHIVE="terramate_${TERRAMATE_VERSION}_linux_x86_64.tar.gz"
curl -L "https://github.com/terramate-io/terramate/releases/download/v${TERRAMATE_VERSION}/${TERRAMATE_ARCHIVE}" | tar xz -C "$HOME/.local/bin" terramate

# configure tflint
tflint --init

# install kubectl-neat
brew instal krew
kubectl krew install neat
ln -s ~/.krew/bin/kubectl-neat ~/.local/bin/

# install certbot
pipx install certbot
pipx inject certbot certbot-dns-azure

## kubelogin
KUBELOGIN_ZIP=/tmp/kubelogin.zip
curl -Ls https://github.com/Azure/kubelogin/releases/download/v0.1.5/kubelogin-linux-amd64.zip -o "$KUBELOGIN_ZIP"
test "$HOME/.local/bin/kubelogin" && rm -fv "$_"
unzip -j "$KUBELOGIN_ZIP" -d "$HOME/.local/bin/"
rm -f "$KUBELOGIN_ZIP"

npm install -g pajv # required by gitops

# Completions

BASH_CMPL_DIR=.local/share/bash-completion/completions

for COMMAND in conftest flux helm kustomize vcluster; do
  ln -s "${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

for COMMAND in globalprotect terraform; do
  ln -s "${HOME}/.local/share/dotfiles/home/.local/share/${BASH_CMPL_DIR}/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

ln -s "${HOME}/${BASH_CMPL_DIR}/globalprotect" "${HOME}/${BASH_CMPL_DIR}/gp"

kubectl completion bash | tee "$HOME/${BASH_CMPL_DIR}"/{kubectl,k} >/dev/null

cat <<_APPEND >>"$HOME/${BASH_CMPL_DIR}"/k

# brablc
complete -o default -F __start_kubectl k
_APPEND

tsh --completion-script-bash >"$HOME/${BASH_CMPL_DIR}/tsh"

# Docker domain name resolution
HOST_DOCKER_INTERNAL=$(ip -j addr show docker0 | jq -r .[0].addr_info.[0].local)
echo -e "[Resolve]\nDNSStubListenerExtra=$HOST_DOCKER_INTERNAL" | sudo tee /etc/systemd/resolved.conf.d/docker.conf
sudo systemctl restart systemd-resolved.service
jq --arg ip "$HOST_DOCKER_INTERNAL" '. + {dns:[$ip]}' /etc/docker/daemon.json | sponge | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker.service
