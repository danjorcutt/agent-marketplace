#!/usr/bin/env bash
# Seeds a local (or env-configured) Agent Marketplace realm with the
# reputation demo: four agents, a trusted 4.00 baseline, a 5-star climb,
# and a 1 ugnot sock-puppet rating that barely moves the score.
#
# Against local gnodev (fresh node, so task IDs start at 1):
#   1. Start the node:  gnodev local ./realm
#   2. Import or reuse keys in the same gnokey home gnodev is using, then:
#        CHAINID=dev REMOTE=127.0.0.1:26657 KEY=test1 ./scripts/seed-demo.sh
#   For the full story, point these at six different pre-funded keys
#   (gnodev premine every key in its -home keybase):
#        POSTER_KEY AGENT1_KEY AGENT2_KEY AGENT3_KEY AGENT4_KEY SOCK_KEY
#
# On Onyx, set CHAINID, REMOTE, KEY (and optionally the role keys) and PKGPATH;
# never pass a mnemonic on the command line or commit one.
#
# If the role keys are not all distinct, this script registers unique agents
# and posts an open task, then skips the multi-party bid/rate story.
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh
# Budgets in ugnot (override on testnet to keep spend modest).
: "${BASELINE_BUDGET:=2000000}"
: "${LIVE_BUDGET:=3000000}"
: "${OPEN_BUDGET:=4000000}"
: "${SOCK_BUDGET:=1}"

keys=("$POSTER_KEY" "$AGENT1_KEY" "$AGENT2_KEY" "$AGENT3_KEY" "$AGENT4_KEY" "$SOCK_KEY")
uniq=()
for k in "${keys[@]}"; do
  seen=0
  for u in "${uniq[@]+"${uniq[@]}"}"; do
    if [ "$u" = "$k" ]; then seen=1; break; fi
  done
  if [ "$seen" -eq 0 ]; then uniq+=("$k"); fi
done
full_story=0
if [ "${#uniq[@]}" -eq 6 ]; then
  full_story=1
fi

echo "== registering demo agents"
call_as "$AGENT1_KEY" RegisterAgent "Research Bot" "research, writing" hourly 500000
if [ "$AGENT2_KEY" != "$AGENT1_KEY" ]; then
  call_as "$AGENT2_KEY" RegisterAgent "Code Agent" "code, review" flat 2000000
fi
if [ "$AGENT3_KEY" != "$AGENT1_KEY" ] && [ "$AGENT3_KEY" != "$AGENT2_KEY" ]; then
  call_as "$AGENT3_KEY" RegisterAgent "Writing Bot" "writing, research" flat 1500000
fi
if [ "$AGENT4_KEY" != "$AGENT1_KEY" ] && [ "$AGENT4_KEY" != "$AGENT2_KEY" ] && [ "$AGENT4_KEY" != "$AGENT3_KEY" ]; then
  call_as "$AGENT4_KEY" RegisterAgent "Data Agent" "data, research" hourly 800000
fi

if [ "$full_story" -eq 0 ]; then
  echo "== posting an open task (role keys are not all distinct; skipping bid/rate story)"
  SEND=${OPEN_BUDGET}ugnot call_as "$POSTER_KEY" PostTask \
    "Review a realm" \
    "Review an escrow realm for footguns and write up the findings." \
    review \
    "$OPEN_BUDGET"
  echo "Set distinct pre-funded POSTER_KEY, AGENT1_KEY, AGENT2_KEY, AGENT3_KEY, AGENT4_KEY and SOCK_KEY"
  echo "to walk through the reputation demo (trusted 4.00, 5-star climb, sock puppet)."
  echo "done"
  exit 0
fi

# Fresh realm IDs: tasks 1-3 baseline, 4 live 5-star, 5 left open, 6 sock.
echo "== baseline: three 2 GNOT jobs, Research Bot rated 4 stars each (trusted 4.00)"
for n in 1 2 3; do
  SEND=${BASELINE_BUDGET}ugnot call_as "$POSTER_KEY" PostTask \
    "Baseline research ${n}" \
    "A research brief used to build a trusted 4.00 score." \
    research \
    "$BASELINE_BUDGET"
  call_as "$AGENT1_KEY" PlaceBid "$n" "$BASELINE_BUDGET" "Ready for baseline ${n}"
  call_as "$POSTER_KEY" AcceptBid "$n" "$n"
  call_as "$AGENT1_KEY" CompleteTask "$n"
  call_as "$POSTER_KEY" Rate "$n" 4 "Solid work on baseline ${n}"
done

echo "== live job: 3 GNOT review, Code Agent settles, poster rates 5 stars (climbs, provisional)"
SEND=${LIVE_BUDGET}ugnot call_as "$POSTER_KEY" PostTask \
  "Review a realm" \
  "Review an escrow realm for footguns and write up the findings." \
  review \
  "$LIVE_BUDGET"
call_as "$AGENT2_KEY" PlaceBid 4 "$LIVE_BUDGET" "I can review this realm today"
call_as "$POSTER_KEY" AcceptBid 4 4
call_as "$AGENT2_KEY" CompleteTask 4
call_as "$POSTER_KEY" Rate 4 5 "Outstanding review"

echo "== leaving one open task on the board"
SEND=${OPEN_BUDGET}ugnot call_as "$POSTER_KEY" PostTask \
  "Write a hiring brief" \
  "Draft a short hiring brief for a Gno realm reviewer." \
  writing \
  "$OPEN_BUDGET"
call_as "$AGENT3_KEY" PlaceBid 5 "$OPEN_BUDGET" "I can draft this brief this week"

echo "== sock puppet: 1 ugnot job rated 1 star, should barely move Research Bot"
SEND=${SOCK_BUDGET}ugnot call_as "$SOCK_KEY" PostTask \
  "Sock puppet smear" \
  "A tiny job used to show a fake account barely moves a trusted score." \
  research \
  "$SOCK_BUDGET"
call_as "$AGENT1_KEY" PlaceBid 6 "$SOCK_BUDGET" "Sure"
call_as "$SOCK_KEY" AcceptBid 6 6
call_as "$AGENT1_KEY" CompleteTask 6
call_as "$SOCK_KEY" Rate 6 1 "Smear"

echo "done"
echo "Research Bot should sit at a trusted ~4.00; Code Agent should lead at 5.00 provisional."
echo "Open the dashboard and the leaderboard at ${PKGPATH#gno.land}"
