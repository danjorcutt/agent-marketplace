#!/usr/bin/env bash
# Seeds a local (or env-configured) Agent Marketplace realm with a few demo
# agents and tasks so the gnoweb dashboard has something to show.
#
# Against local gnodev:
#   1. Start the node:  gnodev local ./realm
#   2. Import or reuse keys in the same gnokey home gnodev is using, then:
#        CHAINID=dev REMOTE=127.0.0.1:26657 KEY=test1 ./scripts/seed-demo.sh
#   For a full bid/accept/settle walk-through, point POSTER_KEY, AGENT1_KEY and
#   AGENT2_KEY at three different pre-funded keys (gnodev premine every key in
#   its -home keybase).
#
# On Onyx, set CHAINID, REMOTE, KEY (and optionally the role keys) and PKGPATH;
# never pass a mnemonic on the command line or commit one.
#
# If all role keys are the same address, this script only registers one agent
# and posts open tasks (a single address cannot bid on its own task).
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh

same_keys=0
if [ "$POSTER_KEY" = "$AGENT1_KEY" ] && [ "$AGENT1_KEY" = "$AGENT2_KEY" ]; then
  same_keys=1
fi

echo "== registering demo agents"
call_as "$AGENT1_KEY" RegisterAgent "Research Bot" "research, writing" hourly 500000
if [ "$same_keys" -eq 0 ]; then
  call_as "$AGENT2_KEY" RegisterAgent "Code Agent" "code, review" flat 2000000
fi

echo "== posting tasks (budget is sent as escrow)"
SEND=3000000ugnot call_as "$POSTER_KEY" PostTask \
  "Summarize a paper" \
  "Write a one-page summary of the Gno VM paper I will provide." \
  research \
  3000000
SEND=4000000ugnot call_as "$POSTER_KEY" PostTask \
  "Review a realm" \
  "Review an escrow realm for footguns and write up the findings." \
  review \
  4000000

if [ "$same_keys" -eq 1 ]; then
  echo "POSTER_KEY, AGENT1_KEY and AGENT2_KEY are the same; skipping bids (a poster cannot bid on their own task)."
  echo "Set distinct pre-funded keys to walk through bid / accept / settle."
  echo "done"
  exit 0
fi

echo "== bidding, accepting, settling task 1; leaving task 2 open"
call_as "$AGENT1_KEY" PlaceBid 1 2500000 "I will deliver a one-page summary tomorrow"
# Task 2 requires 'review', which Code Agent lists.
call_as "$AGENT2_KEY" PlaceBid 2 3500000 "I can review this realm this week"
call_as "$POSTER_KEY" AcceptBid 1 1
call_as "$AGENT1_KEY" CompleteTask 1
echo "done"
