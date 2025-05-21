if [ -d /home/linuxbrew ]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# If not running interactively, don't do anything slow
[ -z "$PS1" ] && return

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias mc='source /usr/lib/mc/mc-wrapper.sh -d'

source /usr/share/doc/fzf/examples/key-bindings.bash
# link from /home/linuxbrew/.linuxbrew}/etc/bash_completion.d/  manually to $HOME/.local/share/bash-completion/completions
# see available: find {/usr/share,$HOME/.local/share}/bash-completion/completions | sort
source /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/completions/fzf
