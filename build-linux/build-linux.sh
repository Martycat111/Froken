#!/bin/sh
printf '\033c\033]0;%s\a' froken
base_path="$(dirname "$(realpath "$0")")"
"$base_path/build-linux" "$@"
