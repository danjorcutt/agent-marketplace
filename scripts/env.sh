# Shared settings for the Magna Coda (agentmarketplace realm) scripts.
# Defaults target a local gnodev node (chain ID "dev").
# For Onyx, override in your shell, for example:
#   CHAINID=onyx-1 REMOTE=https://rpc.onyx.testnets.gno.land:443
#   KEY=<your gnokey name> PKGPATH=gno.land/r/<addr>/agentmarketplace
: "${CHAINID:=dev}"
: "${REMOTE:=127.0.0.1:26657}"
: "${KEY:=test1}"                              # gnokey key name; never commit a mnemonic
: "${PKGPATH:=gno.land/r/demo/agentmarketplace}"
: "${GAS_FEE:=1000000ugnot}"
: "${GAS_WANTED:=30000000}"
# Optional: file holding the keybase password, for unattended runs.
: "${PASSWORD_FILE:=}"
# Optional: gnokey / gnodev home directory (useful for a throwaway local keybase).
: "${GNO_HOME:=}"
# Multi-party seed: if unset, role keys fall back to KEY.
: "${POSTER_KEY:=$KEY}"
: "${AGENT1_KEY:=$KEY}"
: "${AGENT2_KEY:=$KEY}"
: "${AGENT3_KEY:=$KEY}"
: "${AGENT4_KEY:=$KEY}"
: "${SOCK_KEY:=$KEY}"

home_flags=()
if [ -n "$GNO_HOME" ]; then
  home_flags=(-home "$GNO_HOME")
fi

call_as() { # call_as <key> <Func> [args...]   (set SEND=...ugnot for PostTask)
  local key="$1"; shift
  local fn="$1"; shift
  local argv=()
  local send_flags=()
  for a in "$@"; do argv+=(-args "$a"); done
  if [ -n "${SEND:-}" ]; then
    send_flags=(-send "$SEND")
  fi
  if [ -n "$PASSWORD_FILE" ]; then
    gnokey maketx call "${home_flags[@]}" -pkgpath "$PKGPATH" -func "$fn" "${argv[@]}" \
      "${send_flags[@]}" \
      -gas-fee "$GAS_FEE" -gas-wanted "$GAS_WANTED" \
      -chainid "$CHAINID" -remote "$REMOTE" -insecure-password-stdin "$key" < "$PASSWORD_FILE"
  else
    gnokey maketx call "${home_flags[@]}" -pkgpath "$PKGPATH" -func "$fn" "${argv[@]}" \
      "${send_flags[@]}" \
      -gas-fee "$GAS_FEE" -gas-wanted "$GAS_WANTED" \
      -chainid "$CHAINID" -remote "$REMOTE" "$key"
  fi
}
