#!/bin/bash

topl="$(git rev-parse --show-toplevel || echo "${PWD}/..")"
cmds="${topl}/bin"
libs="${topl}/lib"
cpnt="${topl}/component.d"
home="${HOME}/.svc"
user="$(who | awk 'NR==1{print $1}')"

version="$(git describe --tags --always --dirty || echo 'unversioned build')"

inject_version() {
  sed -i -e "s/version=\"\"/version=\"${version}\"/g" "/usr/lib/svc/svc-version"
}

ensure_dirs() {
  mkdir -p "/usr/lib/svc"
  mkdir -p "${home}"

  chown -R ${user}:${user} "${home}"
}

rename_builtins() {
  for cmd in "${cmds}"/*; do
    cmd_name="${cmd%.*}"
    cmd_name="${cmd_name##*/}"

    cp "${cmd}" "/usr/lib/svc/svc-${cmd_name}"
  done
}

copy_main() {
  cp "${topl}/svc" "/usr/local/bin"
}

create_home() {
  cp "${topl}/config" "${home}"
}

main() {
  ensure_dirs
  rename_builtins
  copy_main
  inject_version
  create_home
}

main

