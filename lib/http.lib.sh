curl_service() {
  curl -sS "https://api.github.com/repos/hmrc/${1}" | grep -i 'not found' &>/dev/null \
    && return 1 \
    || return 0
}

