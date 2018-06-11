## imported (usage.lib.sh)

usage() {
  echo -e "${1}"

  exit 0
}

warn() {
  printf "warn: ${1}" "${2}" >&2
}

error() {
  printf "error: ${1}" "${2}" >&2

  exit 0
}

die() {
  printf "fatal: ${1}" "${2}" >&2

  exit 1
}

## imported (parallel.lib.sh)

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
  return ${status}
}

## svc-status

status_usage="\
usage:
  svc status [microservice] [options]

options:
  -p, --port    start on a specified port number
  -b, --branch  start on a specified git branch
  -h, --help    show this help screen

see 'svc help status' for more information"

cmd_status() {
  if [ -z ${services} ]; then
    running="$(find "/var/run/screen/S-${USER}/" -type p)"
    for run in ${running}; do
      services+="${run#*\.} "
    done
  fi

  [ -z "${services}" ] && echo "no services currently running"

  for service in ${services}; do
    parallel "find \"/var/run/screen/S-${USER}/\" -name \"*.${service}\" -type p | grep '.' &>/dev/null \
      && printf \"%-30s %-10s %s\n\" ${service} active $(cd ${WORKSPACE}/${service}; git rev-parse --abbrev-ref HEAD)"

    #if find "/var/run/screen/S-${USER}/" -name "*.${service}" -type p | grep '.' &>/dev/null; then
    #  status="active"

    #  cd ${WORKSPACE}/${service}
    #  branch=$(git rev-parse --abbrev-ref HEAD)

    #  printf "%-30s %-10s %s\n" ${service} ${status} ${branch}
    #fi
  done
 
  reap || die "error showing service status\n"
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -p|--port)   show_l=1 ;;
    -b|--branch) show_r=1 ;;
    -h|--help)   usage "${show_usage}" ;;
    --debug)     debug=1 ;;
    -*)          die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) services+="${1} " ;;

    esac
    shift

  done

  [ ! -z "${debug}" ] && set -x

  source "/usr/lib/svc/svc-parse-config"

  cmd_status
}

main ${@}

