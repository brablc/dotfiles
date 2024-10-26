export PATH="$HOME/.local/bin:$PATH"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups
export HISTIGNORE="[ ]*"
PROMPT_COMMAND="history -a"
shopt -s histappend
alias hn="history -n"

eval "$(zoxide init bash)"

# File system
alias ll='eza -lh --group-directories-first --icons'
alias la='ll -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias cd='z'

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='lazydocker'
