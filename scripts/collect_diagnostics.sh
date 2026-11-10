#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/results/diagnostics-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"
uname -a > "$OUT/uname.txt"
ip -brief address > "$OUT/interfaces.txt"
ip route > "$OUT/routes.txt"
docker ps -a > "$OUT/docker_ps.txt" 2>&1 || true
docker compose ls > "$OUT/docker_compose_ls.txt" 2>&1 || true
printf 'Saved diagnostics in %s\n' "$OUT"
echo 'Inspect and redact subscriber identifiers, IPs, tokens and private information before publishing.'
