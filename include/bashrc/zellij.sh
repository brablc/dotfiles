function zr() { zellij run --name "$*" -- bash -ic "$*"; }
function zrf() { zellij run --name "$*" --floating -- bash -ic "$*"; }
function zri() { zellij run --name "$*" --in-place -- bash -ic "$*"; }
function ze() { zellij edit "$*"; }
function zef() { zellij edit --floating "$*"; }
function zei() { zellij edit --in-place "$*"; }
function zpipe() {
  if [ -z "$1" ]; then
    zellij pipe
  else
    zellij pipe -p "$1"
  fi
}
function zpf() { zellij plugin -- filepicker; }
function znt() {
  local dir=${1:-$PWD}
  local project_dir="$HOME/Projects"
  local select=$dir
  if [[ ! -d $dir ]]; then
    # shellcheck disable=SC2010
    select=$(ls -1 "$project_dir" | grep -i "$1" | fzf --select-1 --exit-0)
    if [[ -z $select ]]; then
      echo "No such dir/project: $dir"
      return
    fi
    dir="$project_dir/$select"
  fi
  zellij action new-tab --layout split-tab --cwd "$dir" --name "${dir##*/}"
}
