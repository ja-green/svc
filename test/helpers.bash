#!/bin/bash

test_root=$(dirname "$(readlink -f "${BASH_SOURCE}")")
svc_root=${svc_root:-$(cd "${test_root}/.."; pwd -P)}
svc_main=${svc_main:-${svc_root}/svc}

svc() {
  "${svc_main}" "${@}"
}

echo_to_log() {
  echo "${BATS_TEST_NAME}
    ----------
    ${output}
    ----------
    " >> ${test_log}
}

clear_log() {
  echo -n "" > ${test_log}
}

setup() {
  return
}

teardown() {
  echo_to_log
}

errecho() {
  echo "${@}" >&2
}
