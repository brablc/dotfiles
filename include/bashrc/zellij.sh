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
  DEF_DIR="$HOME/Projects"
  DIR=$(readlink -f "${1-$PWD}")
  if [[ ! -d $DIR ]]; then
    # shellcheck disable=SC2010
    DIR="$DEF_DIR/$(ls -1 "$DEF_DIR" | grep -i "$1" | fzf --select-1 --exit-0)"
  fi
  zellij action new-tab --layout "${2-half}" --cwd "$DIR" --name "${DIR##*/}"
}
