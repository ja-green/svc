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

## svc-config

help_usage="\
usage:
  svc config [options]

options:
  -a, --all   print all available commands
  -m, --man   show man page
  -h, --help  show this help screen

see 'svc help config' for more information"

old_code() {
    case "$key" in    # here it actually checks for keys and stores their values
      somekey)
        # test to see if a key matches a specific set of values
        if [[ $val =~ ^foo$|^bar$|^baz$ ]]; then
          somekey="$val"
        else
          # more error handling
          config_err+=( "unknown value \"$val\" for \"$key\" in config file on line $nr" )
          config_err+=( '  must be "foo" "bar" or "baz"' )
        fi ;;
      anotherkey) anotherkey+=( "$val" ) ;; # allow multiple keys stored in an array
      *) config_err+=( "unknown key \"$key\" in config file on line $nr" )
    esac
}

parse_config() {
  local line key val nr=0
  local config_err=()

  while IFS= read -r line; do
    # keep a running count of which line we're on
    (( ++nr ))
    # ignore empty lines and lines starting with a #
    [[ -z "$line" || "$line" = '#'* ]] && continue

    line="$(echo ${line} | awk '{$1=$1};1')"

    read -r key <<< "${line%% *}"   # grabs the first word and strips trailing whitespace
    read -r val <<< "${line#* =}"    # grabs everything after the first word and strips trailing whitespace
    
    if [ "${key:0:1}" = "[" ] && [ "${key:$((${#key}-1)):1}" = "]" ]; then
      section="${key#'['}"
      section="${section%']'}"
      declare -gA "${section}"
      continue
    fi

    if [[ -z "${val}" ]]; then
      # store errors in an array
      config_err+=("missing value for '${key}' in config file, line ${nr}")
      continue
    fi
    
    case "${section}" in
       core) case "${key}" in
             team|pager) eval "${section}[${key}]=${val}" ;;
                      *) config_err+=("unknown key '${key}' in config file, line ${nr}") ;;
             esac ;;
    profile) case "${key}" in
             *)          eval "${section}[${key}]=${val}" ;;
             esac ;;

      ports) case "${key}" in
             *)          eval "${section}[${key}]=${val}" ;;
             esac ;;

          *) config_err+=("unknown section '${section}' for key ${key} in config file, line ${nr}") ;;
    esac
  done

  if (( ${#config_err[@]} > 0 )); then
    printf '%s\n' 'there were errors parsing the config file:' "${config_err[@]}"
  fi
}

cmd_config() {
  [ ! -f "${HOME}/.svc/config" ] \
    && die "config file not found\n"

  if [ -f "/dev/shm/checksum" ] && [ -f "/dev/shm/config_cache" ] \
  && [ "$(cat /dev/shm/checksum)" = "$(crc32 ${HOME}/.svc/config)" ]; then
    eval "$(cat /dev/shm/config_cache)"
  
  else
    parse_config < "${HOME}/.svc/config"

    crc32 "${HOME}/.svc/config" > "/dev/shm/checksum"

    local config_cache

    config_cache+="$(declare -p core)\n"
    config_cache+="$(declare -p profile)\n"
    config_cache+="$(declare -p ports)"

    echo -e "${config_cache}" | awk '{$2="-g" OFS $2} 1' > "/dev/shm/config_cache"
  fi
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -a|--all)   all=1 ;;
    -m|--man)   man=1 ;;
    -h|--help)  usage "${help_usage}" ;;
    -*)         die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) die "unknown option '%s'\n" "${1}" ;;

    esac
    shift

  done

  cmd_config
}

main ${@}

