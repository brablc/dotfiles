# shellcheck disable=SC1090

if [ -d /home/linuxbrew ]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  test -v HOMEBREW_PREFIX || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# If not running interactively, don't do anything slow
[ -z "$PS1" ] && return

alias mc='source /usr/lib/mc/mc-wrapper.sh -d'

[[ -n $ZSH_VERSION ]] && return 0

test -f /usr/share/doc/fzf/examples/key-bindings.bash && source "$_"
# link from /home/linuxbrew/.linuxbrew}/etc/bash_completion.d/  manually to $HOME/.local/share/bash-completion/completions
# see available: find {/usr/share,$HOME/.local/share}/bash-completion/completions | sort
test -f /usr/share/bash-completion/bash_completion && source "$_"
test -f /usr/share/bash-completion/completions/fzf && source "$_"
