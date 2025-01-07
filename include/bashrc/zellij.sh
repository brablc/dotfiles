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
    zellij pipe -p $1
  fi
}
function zpf() { zellij plugin -- filepicker; }
function znt() {
  DIR=$(readlink -f ${1-$PWD})
  zellij action new-tab --layout "${2-half}" --cwd "$DIR" --name "${DIR##*/}"
}

function _fzf_subdir_completion() {
  __fzf_generic_path_completion _fzf_compgen_subdir "" "/" "$@"
}
function _fzf_compgen_subdir() {
  command find -L "$1" -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d -maxdepth 1 -a -not -path "$1" -print 2>/dev/null | command sed 's@^\./@@'
}

complete -o nospace -F _fzf_subdir_completion znt
