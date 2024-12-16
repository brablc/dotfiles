#!/usr/bin/env bash

# Installations

brew tap hashicorp/tap
brew install \
  node \
  python@3.10 \
  python@3.11 \
  cosign \
  fluxcd/tap/flux \
  helm \
  kustomize \
  oras \
  teleport \
  terraform \
  terramate \
  hashicorp/tap/vault \
  yq

sudo mkdir -p /etc/apt/keyrings

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

# prepare kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list # helps tools such as command-not-found to work correctly

# install
sudo apt-get update
sudo apt-get install azure-cli kubectl expect

## kubelogin
KUBELOGIN_ZIP=/tmp/kubelogin.zip
curl -Ls https://github.com/Azure/kubelogin/releases/download/v0.1.5/kubelogin-linux-amd64.zip -o "$KUBELOGIN_ZIP"
test "$HOME/.local/bin/kubelogin" && rm -fv "$_"
unzip -j "$KUBELOGIN_ZIP" -d "$HOME/.local/bin/"
rm -f "$KUBELOGIN_ZIP"

npm install -g pajv # required by gitops

# Completions

BASH_CMPL_DIR=.local/share/bash-completion/completions

for COMMAND in conftest flux helm kustomize; do
  ln -s "${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

for COMMAND in globalprotect terraform; do
  ln -s "${HOME}/.local/share/dotfiles/home/.local/share/${BASH_CMPL_DIR}/${COMMAND}" "${HOME}/${BASH_CMPL_DIR}/"
done

kubectl completion bash | tee "$HOME/${BASH_CMPL_DIR}"/{kubectl,k} >/dev/null

cat <<_APPEND >>"$HOME/${BASH_CMPL_DIR}"/k

# brablc
complete -o default -F __start_kubectl k
_APPEND

tsh --completion-script-bash >"$HOME/${BASH_CMPL_DIR}/tsh"

# Tricks for neovim

python3.12 -m venv "$HOME/.local/share/nvim-venv"
source "$HOME/.local/share/nvim-venv/bin/activate"
pip install tree-sitter-make==0.0.1
pip install lsp-tree-sitter
pip install autotools-language-server==0.0.21
deactivate
