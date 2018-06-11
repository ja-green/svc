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

## svc-version

version=""

version_usage="\
usage:
  svc version

see 'svc help version' for more information"

cmd_version() {
  echo "svc ${version}"
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -h|--help)  usage "${version_usage}" ;;
    -*)         die "fatal: unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) die "fatal: unknown option '%s'\n" "${1}" ;;

    esac
    shift

  done

  source "/usr/lib/svc/svc-parse-config"

  cmd_version
}

main ${@}

