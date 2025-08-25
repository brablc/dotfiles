# Zsh-specific compatibility layer for bash configurations

# Zsh history settings (override bash settings)
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Zsh equivalent of noclobber
setopt NO_CLOBBER

# Enable zsh completion system
autoload -Uz compinit
compinit

# Zsh completions paths
if [[ -d /usr/share/zsh-completions ]]; then
  fpath=(/usr/share/zsh-completions $fpath)
fi

# Homebrew completions if available
if [[ -d "${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/share/zsh/site-functions" ]]; then
  fpath=("${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}/share/zsh/site-functions" $fpath)
fi

# Override bash-specific key bindings with zsh versions
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# Convert bash completions to zsh
function _nw() {
  local -a commands
  commands=(${(f)"$(compgen -c)"})
  _describe 'commands' commands
}
compdef _nw nw

function _ssh_hosts() {
  local -a hosts
  if [[ -f ~/.ssh/config ]]; then
    hosts=(${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
  fi
  _describe 'ssh hosts' hosts
}
compdef _ssh_hosts ssh

# Convert PROMPT_COMMAND to zsh hook for envinit
if declare -f envinit >/dev/null; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd envinit
fi

# Enable emacs-style key bindings
bindkey -e

# Only bind keys that might not work properly by default or are terminal-specific
bindkey '^[[3~' delete-char          # Delete key (terminal-specific)
bindkey '^[[H' beginning-of-line     # Home key (terminal-specific)
bindkey '^[[F' end-of-line          # End key (terminal-specific)
bindkey '^[[1~' beginning-of-line    # Home key (alternative sequence)
bindkey '^[[4~' end-of-line         # End key (alternative sequence)

# Override zellij functions to use zsh instead of bash
function zr() { zellij run --name "$*" -- zsh -ic "$*"; }
function zrf() { zellij run --name "$*" --floating -- zsh -ic "$*"; }
function zri() { zellij run --name "$*" --in-place -- zsh -ic "$*"; }
