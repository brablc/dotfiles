function k_podstate() {
  kubectl get pods -A -o json | jq -r '
    .items[] |
    .status.containerStatuses[] as $cs |
    {
      ns: .metadata.namespace,
      name: $cs.name,
      image: $cs.image,
      phase: .status.phase,
      startedAt: ($cs.state.running.startedAt // "N/A"),
      state: (
        if $cs.state.running then "Running"
        elif $cs.state.waiting then "Waiting"
        elif $cs.state.terminated then "Terminated"
        else "Unknown"
        end
      )
    } | [.ns, .name, .image, .phase, .state, .startedAt] | @tsv' | sort
}

function k_monitor() {
  multitail \
    -cS flux -l 'flux logs --since=1h -A -f --kind Kustomization' \
    -cS k8s-events -l 'kubectl get events -A -w'
}

function k_ecs() {
  jq -c '{ts:."@timestamp", level:."log.level", message:.message, origin: ."log.origin".file.name}'
}
