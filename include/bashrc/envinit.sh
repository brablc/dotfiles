# shellcheck disable=SC1090,SC1091

function envinit() {
  ENVINIT_DIR=$HOME/.config/envinit${PWD//$HOME/}
  ENVINIT_SOURCE_FILE="$ENVINIT_DIR/source.sh"

  if [[ -f $ENVINIT_SOURCE_FILE ]]; then
    source "$ENVINIT_SOURCE_FILE"
  elif [[ -f ./env_setup.sh ]]; then
    ENVINIT_DIR=$PWD
    source ./env_setup.sh
  elif [[ -f ./.venv ]]; then
    source ./.venv/bin/activate
  fi
}

PROMPT_COMMAND="envinit; $PROMPT_COMMAND"
