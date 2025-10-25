install -m 755 /dev/stdin "$HOME/.local/bin/h" < <(curl -s -L https://raw.githubusercontent.com/paoloantinori/hhighlighter/master/h.sh\?safe)

echo 'h "$@"' >>"$HOME/.local/bin/h"
