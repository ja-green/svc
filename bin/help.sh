## imported

usage() {
  echo -e "${1}"

  exit 0
}

die() {
  printf "${1}" "${2}" >&2

  exit 1
}

## svc-help

main_usage="\
svc - manage microservices

usage:
  svc [options]
  svc [command] [options]
  svc [command] [subcommand]

commands:                                 
  start           start running a service
  stop            stop a running service
  status          view the status of services    
  log             show service output
  help            show help information
  version         show version information
                                         
options:                                 
  -h, --help      show help information 
  -v, --version   show version informtion
                                       
see 'svc help' for help with a
specific command, component or concept

see 'svc help -a' for a list of 
all available commands"

help_usage="\
usage:
  svc help [options]
  svc help [command]
  svc help [concept]

options:
  -a, --all   print all available commands
  -p, --ports list all known ports
  -m, --man   show man page
  -h, --help  show this help screen

see 'svc help help' for more information"

commands_list="\
builtin commands available from '/usr/lib/svc':
  start     start running a service
  stop      stop a running service
  status    view the status of services
  log       show service output
  help      show help information
  version   show version information"

list_commands() {
  user_supplied="$(compgen -ac | grep 'svc-' | sed -e 's/^svc-//')"

  echo -e "${commands_list}"

  if [ ! -z "${user_supplied}" ]; then
    echo -e "\ncustom commands available from elsewhere in your \$PATH"

    for command in ${user_supplied}; do
      echo "  ${command}"
    done
  fi

  echo -e "\nsee 'svc help' for help with a specific command or concept"

}

list_ports() {
  for i in "${!ports[@]}"; do
    printf "%-40s %s\n" "${i}" "${ports[${i}]}"
  done
}

cmd_help() {
  if [ ! -z "${show_cmd}" ]; then
    list_commands
  elif [ ! -z "${show_man}" ]; then
    man svc 2>/dev/null \
    || die "no help text for svc\n"
  elif [ ! -z "${show_ports}" ]; then
    list_ports | grep "${sub_cmd:-.}"
  elif [ -z "${sub_cmd}" ]; then
    usage "${main_usage}"

  else
    man "svc${sub_cmd}" 2>/dev/null     \
    || man "svc-${sub_cmd}" 2>/dev/null \
    || die "no help text for '%s'\n" "${sub_cmd}"
  fi
}

main() {
  while [ -n "${1}" ]; do
    case "${1}" in
    --) shift; break;;
    -*) case "${1}" in
    -a|--all)   show_cmd=1 ;;
    -m|--man)   show_man=1 ;;
    -p|--ports) show_ports=1 ;;
    -h|--help)  usage "${help_usage}" ;;
    -*)         die "unknown option '%s'\n" "${1}" ;;
    esac ;;

    *) [ -z "${sub_cmd}" ] && sub_cmd="${1}" ;;

    esac
    shift

  done

  source "/usr/lib/svc/svc-parse-config"

  cmd_help
}

main ${@}

