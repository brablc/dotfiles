echo "Install starship manually: curl -sS https://starship.rs/install.sh | sh"

sudo apt install -y \
  apache2-utils \
  apt-file \
  bat \
  btop \
  expect \
  eza \
  fd-find \
  fzf \
  gh \
  postgresql-client \
  pipx \
  plocate \
  ripgrep \
  tldr \
  yq \
  zoxide

curl -Ls https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xzf - && mv -v zellij ~/.local/bin
zellij setup --generate-completion bash >~/.local/share/bash-completion/completions/zellij

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ln -s ${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/brew "$HOME/.local/share/bash-completion/completions/"

# Tricks for neovim
python3.12 -m venv "$HOME/.local/share/nvim-venv"
source "$HOME/.local/share/nvim-venv/bin/activate"
pip install tree-sitter-make==0.0.1
pip install lsp-tree-sitter
pip install autotools-language-server==0.0.21
deactivate

# curl -sL https://github.com/supabase-community/postgres-language-server/releases/download/0.8.1/postgrestools_x86_64-unknown-linux-gnu -o ~/.local/bin/postgrestools
# chmod +x ~/.local/bin/postgrestools

# disable IPv6
# echo -e "\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6=1\nnet.ipv6.conf.default.disable_ipv6=1\nnet.ipv6.conf.lo.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
# sudo sysctl -p

# Inotify
# echo -e "\n# Inotify\nfs.inotify.max_user_instances=1024\nfs.inotify.max_user_watches=524288\nfs.inotify.max_queued_events=32768\n" | sudo tee -a /etc/sysctl.conf
# sudo sysctl -p
