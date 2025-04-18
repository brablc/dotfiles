install -m 644 /dev/stdin "$HOME/.local/bin/h.sh" < <(curl -s -L https://raw.githubusercontent.com/paoloantinori/hhighlighter/master/h.sh\?safe | sed -E 's/^h\(/hhighlighter\(/')
