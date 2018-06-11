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

## svc-log

log_usage="\
usage:
  svc log [microservice] [options]

options:
  -p, --pager     pager to use
  -n, --no-pager  print directly to stdout
  -h, --help      show this help screen

see 'svc help log' for more information"

cmd_log() {
  for service in ${services}; do
    if [ ! -z "${no_pager}" ]; then
      cat "/tmp/svc/${service}.log"

    elif [ ! -z "${pager}" ]; then
      type "${pager}" &>/dev/null || die "unknown pager '${pager}'\n"
      [ "${pager}" = "less" ] && pager="less -R"
      eval "${pager}" "/tmp/svc/${service}.log"
    elif [ ! -z "${PAGER}" ]; then
      type "${PAGER}" &>/dev/null || die "unknown pager '${PAGER}'\n"
      [ "${PAGER}" = "less" ] && PAGER="less -R"
      eval "${PAGER}" "/tmp/svc/${service}.log"

    elif type more; then
      more "/tmp/svc/${service}.log"

    else
      die "no default pager found\n"
    fi
  done
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -p|--pager)    [ ! -z "${2}" ] && pager="${2}"; shift || die "option '${1}' requires an argument\n" ;;
    -n|--no-pager) no_pager=1 ;;
    -h|--help)     usage "${log_usage}" ;;
    --debug)       debug=1 ;;
    -*)            die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) services+="${1} " ;;

    esac
    shift

  done

  source "/usr/lib/svc/svc-parse-config"

  [ ! -z "${debug}" ] && set -x

  cmd_log
}

main ${@}

