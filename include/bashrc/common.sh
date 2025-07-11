export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8
export LC_TIME="POSIX"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VIEWER="view"

# If not running interactively, don't do anything slow
[ -z "$PS1" ] && return

export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups
export HISTIGNORE="[ ]*"
PROMPT_COMMAND="history -a"
shopt -s histappend
alias hn="history -n"
alias hdn="export HISTFILE=/dev/null"

[[ -n "$(find "$HISTFILE" -mmin +120)" ]] && install -m 600 <(gzip <"$HISTFILE") "$HISTFILE.$(date +%w).gz"

eval "$(zoxide init bash --hook prompt)"

# File system
alias ll='eza -lh --group-directories-first --icons'
alias la='ll -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias gcd='cd $(git rev-parse --show-toplevel)'

# alias cd='z'

# Tools
alias bat='batcat'
alias c="column -s $'\t' -t"
alias d='docker'
alias g='git'
alias k='kubectl'
alias lzd='lazydocker'
alias lzg='lazygit'
alias n='nvim'
alias r='rails'

function h() {
  source "$HOME/.local/bin/h.sh"
  hhighlighter "$@"
}

function clp() {
  printf ".%.0s\n" $(seq $LINES)
}

# Completion
function nw() {
  if [[ -f $1 ]]; then
    nvim "$1"
  else
    nvim "$(which "$1")"
  fi
}

function _nw {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  readarray -t COMPREPLY < <(compgen -c -- "${cur}")
  return 0
}
complete -F _nw nw

function _ssh {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts=$(<~/.ssh/config perl -lane 'if (/Host(?:Name)? (.*)/) { $_=$1; s/ /\n/g; print;}' | sort -u)

  readarray -t COMPREPLY < <(compgen -W "$opts" -- "${cur}")
  return 0
}
complete -F _ssh ssh
