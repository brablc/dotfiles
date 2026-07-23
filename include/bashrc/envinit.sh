# shellcheck disable=SC1090,SC1091

function envinit_log() {
  printf "\033[1;32m-I|envinit|%s\033[0m\n" "$@"
}

function envinit_save() {
  local shadow_dir="$HOME/.config/envinit${PWD//$HOME/}"
  local base="${PWD##*/}" stripped base_shadow=""
  stripped="${base%.*}"
  if [[ $stripped != "$base" ]]; then
    local parent="${PWD%/*}"
    local candidate="$HOME/.config/envinit${parent//$HOME/}/$stripped/source.sh"
    [[ -f $candidate ]] && base_shadow="$candidate"
  fi

  mkdir -p "$shadow_dir"
  {
    [[ -n $base_shadow ]] && printf 'source "%s"\n' "$base_shadow"
    printf 'source "%s/activate.sh"\n' "$KS_DIR"
    printf 'source <(ks -l "%s")\n' "$KS_SITE"
  } >|"$shadow_dir/source.sh"
  envinit_log "Created $shadow_dir/source.sh"
  ENVINIT_SHADOW="$shadow_dir/source.sh"
}

function envinit() {
  local shadow_dir
  shadow_dir=$HOME/.config/envinit${PWD//$HOME/}
  mkdir -p "$shadow_dir"
  #shellcheck disable=SC2034
  ENVINIT_SHADOW="$shadow_dir/source.sh"

  if [[ -n $ENVINIT_DIR && $PWD =~ $ENVINIT_DIR ]]; then
    return
  fi

  if [[ -f $shadow_dir/source.sh ]]; then
    ENVINIT_DIR=$PWD
    source "$shadow_dir/source.sh"
    envinit_log "$shadow_dir/source.sh"
  fi
  if [[ -f env_setup.sh ]]; then
    ENVINIT_DIR=$PWD
    source env_setup.sh
    envinit_log "env_setup.sh"
  fi
  if [[ -d .venv ]]; then
    ENVINIT_DIR=$PWD
    source .venv/bin/activate
    envinit_log ".venv"
  fi
  if [[ -d venv ]]; then
    ENVINIT_DIR=$PWD
    source venv/bin/activate
    envinit_log "venv"
  fi
  if [[ -f activate.sh ]]; then
    ENVINIT_DIR=$PWD
    source activate.sh
    envinit_log "activate.sh"
  fi
}

PROMPT_COMMAND="envinit; $PROMPT_COMMAND"
