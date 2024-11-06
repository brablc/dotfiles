echo "Install starship manually: curl -sS https://starship.rs/install.sh | sh"

sudo apt install -y fzf ripgrep bat eza zoxide plocate btop apache2-utils fd-find tldr

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ln -s ${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/etc/bash_completion.d/brew ${HOME}/.local/share/bash-completion/completions/
