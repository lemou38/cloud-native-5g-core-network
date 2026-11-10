#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$ROOT/vendor/docker_open5gs"
if [[ -e "$DEST" ]]; then echo "Existing upstream checkout: $DEST"; exit 0; fi
command -v git >/dev/null || { echo 'Install git first' >&2; exit 1; }
mkdir -p "$ROOT/vendor" "$ROOT/results"
git clone https://github.com/herlesupreeth/docker_open5gs.git "$DEST"
(cd "$DEST" && git rev-parse HEAD) | tee "$ROOT/results/upstream_commit.txt"
echo 'Review vendor/docker_open5gs/README.md for the supported 5G SA deployment profile.'
