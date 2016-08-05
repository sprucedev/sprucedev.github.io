#!/bin/bash
dockerfile_url="${1:-http://spruce.sh/deploy/Dockerfile}"
base_url="$(dirname "$dockerfile_url")"

function run {
  echo "RUN   : $1"
  echo "$1" | bash
}
function copy {
  from="$base_url/$(echo "$1" | awk '{print $1}')"
  to="$(echo "$1" | awk '{print $2}')"
  echo "COPY  : FROM : $from"
  echo "        TO   : $to"
  curl --fail -o "$to" "$from" || exit $?
}
function comment {
  echo "        $1"
}
function other {
  block="$(echo "$1" | awk '{print $1}')"
  echo "ERROR : UNKNOWN BLOCK TYPE: $block" >&2
}

DOCKERFILE="$(curl --fail "$dockerfile_url")"
curl_exit=$?; [[ $curl_exit -eq 0 ]] || exit $curl_exit
DOCKERFILE_NOBLANK="$(echo "$DOCKERFILE" | awk '/[^ ]/ {print}')"
DOCKERFILE_BETWEEN="$(echo "$DOCKERFILE_NOBLANK" | awk '
  /^### START KS SHARED ###$/ { flag=1; next }
  /^### END KS SHARED ###$/ { flag=0 }
  flag { print }
')"

block='_'
block_idx=0
while [[ "$block" != '' ]]; do
  block="$(echo "$DOCKERFILE_BETWEEN" | awk "
    (flag == $block_idx) { print }
    !/\\\\\$/ { flag++ }
  ")"
  case "$block" in
    "RUN "*) run "${block:4}" ;;
    "COPY "*) copy "${block:5}" ;;
    \#*) comment "${block}" ;;
    '') ;;
    *) other "$block" ;;
  esac
  echo
  block_idx=$((block_idx + 1))
done
