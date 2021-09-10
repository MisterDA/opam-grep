#!/bin/sh

set -e

DST="$HOME/.cache/opam-grep"
PACKAGES="$DST/packages"

sync() {
  mkdir -p "$DST"
  opam show -f package $(opam list -A -s --color=never) > "$PACKAGES"
}

atexit() {
  if test -z "$PKG" -o -z "$DST"; then
    echo "Something went really wrong. Please report."
    exit 1
  fi
  rm -rf "$DST/$PKG"
  exit 1
}

check() {
  PKG="$1" # Used for atexit
  if test ! -e "$DST/$PKG"; then
    trap atexit INT TERM
    opam source --dir "$DST/$PKG" "$PKG" > /dev/null || true
    trap - INT TERM
  fi
}

SPIN='/'
MSG='Searching'

spin() {
  echo -n -e "\033[2K\r$MSG: $SPIN"
  case "$SPIN" in
    '|') SPIN='/';;
    '/') SPIN='-';;
    '-') SPIN='\';;
    '\') SPIN='|';;
  esac
}

search() {
  sync

  for pkg in $(cat "$PACKAGES"); do
    spin
    check "$pkg"
    if grep -qsr -e "$1" "$DST/$pkg"; then
      pkg=$(echo "$pkg" | cut -d. -f1)
      echo -e "\033[2K\r$pkg matches your regexp."
    fi
  done
  echo -e '\033[2K\rUpdate complete.'
}

case "$1" in
--help)
  if test "$#" -gt 1; then
    echo "Too many arguments."
    exit 1
  fi
  echo "Usage:"
  echo "  - $0 --help"
  echo "  - $0 --version"
  echo "  - $0 [--regexp] <regexp>"
  ;;
--version)
  if test "$#" -gt 1; then
    echo "Too many arguments."
    exit 1
  fi
  echo "0.1.1"
  ;;
--regexp)
  if test "$#" -lt 2; then
    echo "Not enough arguments."
    exit 1
  elif test "$#" -gt 2; then
    echo "Too many arguments."
    exit 1
  fi
  search "$2"
  ;;
--*)
  echo "Option '$1' unknown."
  exit 1
  ;;
*)
  if test "$#" -lt 1; then
    echo "Not enough arguments."
    exit 1
  elif test "$#" -gt 1; then
    echo "Too many arguments."
    exit 1
  fi
  search "$1"
  ;;
esac
