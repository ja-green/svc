## imported (usage.lib.sh)

usage() {
  echo -e "${1}"

  exit 0
}

warn() {
  printf "warn: ${1}" "${2}" >&2

  exit 0
}

error() {
  printf "error: ${1}" "${2}" >&2

  exit 1
}

die() {
  printf "fatal: ${1}" "${2}" >&2

  exit 1
}

## svc-start-service

start_service_usage="\
usage:
  svc start-service [microservice] [options]

options:
  -p, --port    start on a specified port number
  -b, --branch  start on a specified git branch
  -h, --help    show this help screen

see 'svc help start-service' for more information"

cmd_start_service() {
  [ ! -d "${WORKSPACE}/${service}" ] \
    && die "fatal: '${service}' not found in workspace\n"
 
  cd "${WORKSPACE}/${service}"
  git checkout -q ${branch:-master}

  for file in $(git ls-files); do
    extn+="${file#*.} "
  done

  lang="$(echo ${extn} | xargs -n1 | sort | uniq -c | sort -nr | head -1)"
  lang="${lang##* }"

  mkdir -p /tmp/svc/
  touch /tmp/svc/${service}.log
  touch /tmp/svc/sconf
  echo -n "" > /tmp/svc/${service}.log

  echo -e "logfile /tmp/svc/${service}.log\nlogfile flush 1\nlog on" > /tmp/svc/${service}.conf

  if find "/var/run/screen/S-${USER}/" -name "*.${service}" -type p | grep '.' &>/dev/null; then
    warn "'${service}' already running\n"
  else
    case "${lang}" in
    scala) screen -c /tmp/svc/${service}.conf -dmSL ${service} sbt "run ${port}" ;;
     scss) screen -c /tmp/svc/${service}.conf -dmSL ${service} npm start         ;;
        *) error "unknown language '${lang}' in '${service}'\n" ;;
    esac

    echo "started '${service}' on port ${port}"
  fi 
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -p|--port)   [ ! -z "${2}" ] && port="${2}";   shift || die "option '${1}' requires an argument" ;;
    -b|--branch) [ ! -z "${2}" ] && branch="${2}"; shift || die "option '${1}' requires an argument" ;;
    -h|--help)   usage "${start_service_usage}" ;;
    --debug)     debug=1 ;;
    -*)          die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) [ -z "${service}" ] && service="${1}" ;;

    esac
    shift

  done

  [ ! -z "${debug}" ] && set -x

  source "/usr/lib/svc/svc-parse-config"

  cmd_start_service
}

main ${@}

