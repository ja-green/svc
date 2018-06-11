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

  unset JOBS

  return ${status}
}

## svc-start

start_usage="\
usage:
  svc start [microservice] [options]

options:
  -p, --port      start on a specified port number
  -b, --branch    start on a specified git branch
  -n, --no-verify bypass verification step
  -h, --help      show this help screen

see 'svc help start' for more information"

cmd_start() {
  if [ ! -z "${no_verify}" ]; then
    warn "bypassing verification step\n"
  else
    for service in ${services}; do
      parallel "curl_service ${service}" "${service}"
    done
  fi

  if ! reap; then
    [ ${profile[${service}]+_} ] \
      && services=${profile[${service}]} \
      || die "'${failed}' is not a recognised microservice or profile\n"
  fi

  for service in ${services}; do
    if [ ! -d "${WORKSPACE}/${service}" ]; then
      warn "no local source for '${service}' found - fetching from remote\n"
      parallel "git clone git@github.com:hmrc/${service}.git ${WORKSPACE}/${service} &>/dev/null" "${service}"
    fi
  done

  reap || die "error fetching '${failed}' from the remote repository\n"

  for service in ${services}; do
    svc start-service ${service} -p ${port:-${ports[${service}]}}
  done

  reap || die "error starting service '${failed}'\n"
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -p|--port)   port=1 ;;
    -b|--branch) branch=1 ;;
    -n|--no-verify) no_verify=1 ;;
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

  cmd_start
}

main ${@}

