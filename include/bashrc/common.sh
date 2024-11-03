export PATH="$HOME/.local/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8
export LC_TIME="POSIX"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VIEWER="view"

export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups
export HISTIGNORE="[ ]*"
PROMPT_COMMAND="history -a"
shopt -s histappend
alias hn="history -n"
alias hdn="export HISTFILE=/dev/null"

eval "$(zoxide init bash)"

# File system
alias ll='eza -lh --group-directories-first --icons'
alias la='ll -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
# alias cd='z'

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='lazydocker'

# Completion
function nvimw() {
  if [[ -f "$1" ]]; then
    nvim $1
  else
    nvim $(which $1)
  fi
}

function _nvimw {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  COMPREPLY=($(compgen -c -- ${cur}))
  return 0
}
complete -F _nvimw nvimw

function _ssh {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  opts=$(<~/.ssh/config perl -lane 'if (/Host(?:Name)? (.*)/) { $_=$1; s/ /\n/g; print;}' | sort -u)

  COMPREPLY=($(compgen -W "$opts" -- ${cur}))
  return 0
}
complete -F _ssh ssh
