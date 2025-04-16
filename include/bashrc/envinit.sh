# shellcheck disable=SC1090,SC1091

function envinit_log() {
  printf "\033[1;32m-I|envinit|%s\033[0m\n" "$@"
}

function envinit() {
  local shadow_dir
  shadow_dir=$HOME/.config/envinit${PWD//$HOME/}
  if [[ -n $ENVINIT_DIR && $PWD =~ $ENVINIT_DIR ]]; then
    return
  fi

  if [[ -f $shadow_dir/source.sh ]]; then
    ENVINIT_DIR=$PWD
    source "$shadow_dir/source.sh"
    envinit_log "$shadow_dir/source.sh"
  elif [[ -f env_setup.sh ]]; then
    ENVINIT_DIR=$PWD
    source env_setup.sh
    envinit_log "env_setup.sh"
  elif [[ -d .venv ]]; then
    ENVINIT_DIR=$PWD
    source .venv/bin/activate
    envinit_log ".venv"
  fi
}

PROMPT_COMMAND="envinit; $PROMPT_COMMAND"
