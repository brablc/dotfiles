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
  if ((!$#)); then
    zellij action new-tab --layout "${LAYOUT:-default}" --cwd "$HOME"
    return
  fi
  local dir=$1
  if [[ ! -d $dir ]]; then
    local select=$dir
    local project_dir="$HOME/Projects"
    if [[ -n $dir && -d $project_dir/$dir ]]; then
      dir="$project_dir/$dir"
    else
      # shellcheck disable=SC2010
      select=$(ls -1 "$project_dir" | grep -i "$1" | fzf --select-1 --exit-0)
      if [[ -z $select ]]; then
        echo "No such dir/project: $dir"
        return
      fi
      dir="$project_dir/$select"
    fi
  fi
  zellij action new-tab --layout "${LAYOUT:-default}" --cwd "$dir" --name "${dir##*/Projects/}"
}

function znz() {
  LAYOUT=defaultz znt "$@"
}
