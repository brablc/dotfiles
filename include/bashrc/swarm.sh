function _swarm_stacks {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  opts=$(docker stack ls --format "{{.Name}}")

  COMPREPLY=($(compgen -W "$opts" -- ${cur}))
  return 0
}

function _swarm_services {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  opts=$(docker stack ls --format "{{.Name}}" | xargs -L1 docker stack services --format "{{.Name}}")

  COMPREPLY=($(compgen -W "$opts" -- ${cur}))
  return 0
}

function _swarm_shared_swap {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  case $COMP_CWORD in
  1)
    opts=$(docker stack ls --format "{{.Name}}")
    COMPREPLY=($(compgen -W "$opts" -- ${cur}))
    ;;
  2)
    if [[ -n $prev ]]; then
      opts=$(find ~/stack/shared/ -regextype posix-extended -regex ".*/(secret|config)/$prev.*" -printf "%P\n" 2>/dev/null)
      COMPREPLY=($(compgen -W "$opts" -- ${cur}))
    fi
    ;;
  esac
  return 0
}

complete -F _swarm_stacks dst-deploy dst-ps dst-chk-image-updates
complete -F _swarm_services dse-exec dse-logs dse-update
complete -F _swarm_shared_swap swarm-shared-swap

alias dse-psr="dse-ps --filter desired-state=running"
