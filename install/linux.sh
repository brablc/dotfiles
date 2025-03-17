echo "Install starship manually: curl -sS https://starship.rs/install.sh | sh"

sudo apt install -y fzf ripgrep bat eza zoxide plocate btop apache2-utils fd-find tldr gh yq apt-file

curl -Ls https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xzf - && mv -v zellij ~/.local/bin
zellij setup --generate-completion bash >~/.local/share/bash-completion/completions/zellij

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# gh extension install dlvhdr/gh-dash

ln -s ${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/brew "$HOME/.local/share/bash-completion/completions/"

install -m 755 /dev/stdin "$HOME/.local/share/bash-completion/completions/h" < <(curl -s -L https://raw.githubusercontent.com/paoloantinori/hhighlighter/master/h.sh)

# Tricks for neovim

python3.12 -m venv "$HOME/.local/share/nvim-venv"
source "$HOME/.local/share/nvim-venv/bin/activate"
pip install tree-sitter-make==0.0.1
pip install lsp-tree-sitter
pip install autotools-language-server==0.0.21
deactivate

ln -fs "$(which python3)" ~/.local/bin/python
pipx install poetry
poetry self add poetry-git-version-plugin
poetry completions bash >~/.local/share/bash-completion/completions/poetry

# disable IPv6
echo -e "\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6=1\nnet.ipv6.conf.default.disable_ipv6=1\nnet.ipv6.conf.lo.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
