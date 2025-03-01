ENVINIT_DIR=$HOME/.config/envinit/${PWD//$HOME/}
if [[ -f $ENVINIT_DIR/source.sh ]]; then
  source "$ENVINIT_DIR/source.sh"
fi
