# shellcheck disable=SC1091
ENVINIT_DIR=$HOME/.config/envinit/${PWD//$HOME/}
if [[ -f $ENVINIT_DIR/source.sh ]]; then
  source "$ENVINIT_DIR/source.sh"
elif [[ -f ./env_setup.sh ]]; then
  ENVINIT_DIR=$PWD
  source ./env_setup.sh
fi
