#!/usr/bin/env bash
# Deploys the realm in ../realm to PKGPATH. The package path's namespace must be
# the deploying key's own g1 address (or a namespace that key has registered).
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh
: "${DEPLOY_GAS_WANTED:=200000000}"
: "${MAX_DEPOSIT:=}"
extra=()
[ -n "$MAX_DEPOSIT" ] && extra+=(-max-deposit "$MAX_DEPOSIT")
home_flags=()
if [ -n "$GNO_HOME" ]; then
  home_flags=(-home "$GNO_HOME")
fi
pw=()
if [ -n "$PASSWORD_FILE" ]; then
  pw=(-insecure-password-stdin)
  exec < "$PASSWORD_FILE"
fi
gnokey maketx addpkg "${home_flags[@]}" -pkgpath "$PKGPATH" -pkgdir ../realm \
  -gas-fee "$GAS_FEE" -gas-wanted "$DEPLOY_GAS_WANTED" "${extra[@]}" \
  -chainid "$CHAINID" -remote "$REMOTE" "${pw[@]}" "$KEY"
