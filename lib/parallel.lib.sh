declare -A JOBS

parallel() {
  eval $1 & JOBS[$!]="${2:-$@}"
}

reap() {
  local cmd
  local status=0

  for pid in ${!JOBS[@]}; do
    cmd=${JOBS[${pid}]}
    wait ${pid} ; JOBS[${pid}]=$?
    if [[ ${JOBS[${pid}]} -ne 0 ]]; then
      status=${JOBS[${pid}]}
      failed="${cmd}"
      break
    fi
  done

  unset JOBS

  return ${status}
}

