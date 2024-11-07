export PATH="/usr/local/bin:$PATH"

unset -f command_not_found_handle

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

export BASH_SILENCE_DEPRECATION_WARNING=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # https://stackoverflow.com/questions/50168647/multiprocessing-causes-python-to-crash-and-gives-an-error-may-have-been-in-progr

export DYLD_FALLBACK_LIBRARY_PATH=$(brew --prefix libpq)/lib:$DYLD_FALLBACK_LIBRARY_PATH

# Source system-wide bash completion
# brew install bash bash-completion@2 (https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)
# curl -s -L https://github.com/docker/cli/raw/master/contrib/completion/bash/docker > /usr/local/etc/bash_completion.d/docker
source /usr/local/etc/profile.d/bash_completion.sh

alias flushdns='sudo dscacheutil -flushcache'
