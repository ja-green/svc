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

