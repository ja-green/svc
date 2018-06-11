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

## imported (http.lib.sh)

curl_service() {
  curl -sS "https://api.github.com/repos/hmrc/${1}" | grep -i 'not found' &>/dev/null \
    && return 1 \
    || return 0
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

## svc-stop

stop_usage="\
usage:
  svc stop [microservice] [options]

options:
  -a, --all     stop all running services
  -h, --help    show this help screen

see 'svc help stop' for more information"

cmd_stop() {
  if [ ! -z "${all}" ]; then
    running="$(find "/var/run/screen/S-${USER}/" -type p)"
    for run in ${running}; do
      services+="${run#*\.} "
    done
  fi

  for service in ${services}; do
    [ ${profile[${service}]+_} ] \
      && services=${profile[${service}]} 
  done

  for service in ${services}; do
    find "/var/run/screen/S-${USER}/" -name "*.${service}" -type p | grep '.' &>/dev/null \
      && screen -XS ${service} quit \
      || warn "'${service}' not running\n"
  done
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -a|--all)   all=1 ;;
    -h|--help)  usage "${stop_usage}" ;;
    --debug)    debug=1 ;;
    -*)         die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) services+="${1} " ;;

    esac
    shift

  done

  [ ! -z "${debug}" ] && set -x

  source "/usr/lib/svc/svc-parse-config"

  cmd_stop
}

main ${@}

