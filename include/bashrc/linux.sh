export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

source /usr/share/bash-completion/completions/fzf
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/bash-completion/bash_completion
