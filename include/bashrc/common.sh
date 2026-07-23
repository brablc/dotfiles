export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8
export LC_TIME="POSIX"
export COLORTERM=truecolor

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VIEWER="view"

if [ -d "$HOME/go/bin" ]; then
  export PATH="$PATH:$HOME/go/bin"
fi

# If not running interactively, don't do anything slow
[ -z "$PS1" ] && return

# File system
alias ll='eza -lh --group-directories-first --icons'
alias la='ll -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias gcd='cd $(git rev-parse --show-toplevel)'

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

function rt() {
  # shellcheck disable=SC1090
  source <(tmux-rename-tab "$@")
  unset ENVINIT_DIR
}

function gwt() {
  local branch_leaf="$1"
  local branch_dir="${2:-users/$USER}"
  local path="../${PWD##*/}.${branch_leaf}"
  local stash_output stashed
  stash_output=$(git stash 2>&1)
  stashed=$([[ $stash_output == *"No local changes"* ]] && echo 0 || echo 1)
  git worktree add -b "$branch_dir/$branch_leaf" "$path"
  cd "$path" || :
  [[ $stashed -eq 1 ]] && git stash pop
  unset ENVINIT_DIR
}

function gwtprune() {
  # Snapshot origin/* tips before --prune deletes them, so the unpushed check
  # below still sees commits that were pushed to a now-deleted remote branch.
  local pre_origin
  pre_origin=$(git for-each-ref --format='%(objectname)' refs/remotes/origin/)
  git fetch --prune
  local main_wt
  main_wt=$(git worktree list --porcelain | awk '/^worktree / { print substr($0, 10); exit }')
  git worktree list --porcelain | awk '
    /^worktree / { wt = substr($0, 10) }
    /^branch /   { print wt "\t" substr($0, 19) }
  ' | while IFS=$'\t' read -r wt branch; do
    [[ $wt == "$main_wt" ]] && continue
    [[ $wt == "$PWD" ]] && {
      echo "skip $wt (current dir)"
      continue
    }
    git show-ref --verify --quiet "refs/remotes/origin/$branch" && continue
    # shellcheck disable=SC2086
    if [[ -n "$(git rev-list "$branch" --not --remotes=origin $pre_origin --max-count=1 2>/dev/null)" ]]; then
      echo "skip $wt ($branch) — unpushed commits"
      continue
    fi
    echo "removing $wt ($branch)"
    git worktree remove "$wt" && git branch -D "$branch"
  done
}

}

[[ -n $ZSH_VERSION ]] && return 0

export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups
export HISTIGNORE="[ ]*"
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
shopt -s histappend
alias hn="history -n"
alias hdn="export HISTFILE=/dev/null"

set -o noclobber

[[ -n "$(find "$HISTFILE" -mmin +120)" ]] && install -m 600 <(sponge <"$HISTFILE" | gzip) "$HISTFILE.$(date +%w).gz"

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
  opts=$(rg -I -o '^\s*Host(Name)?\b\s+(\w.*)' -r '$2' ~/.ssh/ | xargs printf "%s\n" | sort -u)

  readarray -t COMPREPLY < <(compgen -W "$opts" -- "${cur}")
  return 0
}
complete -F _ssh ssh

eval "$(zoxide init bash --hook prompt)"

if command -v starship &>/dev/null; then
  if [[ -v TMUX ]]; then
    # shellcheck disable=SC2016
    eval "$(starship init bash --print-full-init | sed -E 's|(starship prompt )"|\1--profile tmux_prompt "|g')"
  else
    eval "$(starship init bash)"
  fi
fi

if command -v kubecolor &>/dev/null; then
  alias kubectl='kubecolor'
  alias k='kubecolor'
else
  alias k='kubectl'
fi
