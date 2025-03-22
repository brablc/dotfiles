brew install starship luarocks yq

mkdir -p ~/.local/share/bash-completion/completions
ln -s ~/.local/share/bash-completion ~/.config

curl -Ls https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-apple-darwin.tar.gz | tar xzf - && mv -v zellij ~/.local/bin
zellij setup --generate-completion bash >~/.local/share/bash-completion/completions/zellij
