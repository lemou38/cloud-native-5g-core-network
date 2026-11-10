#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 3 ]]; then echo 'Usage: benchmark.sh DESTINATION COUNT OUTPUT.csv [SOURCE_INTERFACE]' >&2; exit 2; fi
DST="$1"; COUNT="$2"; OUT="$3"; IFACE="${4:-}"
[[ "$COUNT" =~ ^[1-9][0-9]*$ ]] || { echo 'COUNT must be a positive integer' >&2; exit 2; }
mkdir -p "$(dirname "$OUT")"
ARGS=(-n -c "$COUNT" -W 2)
if [[ -n "$IFACE" ]]; then ARGS+=(-I "$IFACE"); fi
TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
ping "${ARGS[@]}" "$DST" > "$TMP" 2>&1 || true
python3 - "$TMP" "$OUT" "$DST" <<'PYCODE'
import csv,re,sys,datetime
src,out,dst=sys.argv[1:]
pattern=re.compile(r'icmp_seq=(\d+).*?time[=<]([\d.]+)\s*ms')
with open(src,encoding='utf-8',errors='replace') as f: lines=f.readlines()
with open(out,'w',newline='',encoding='utf-8') as f:
 w=csv.writer(f);w.writerow(['timestamp_utc','destination','icmp_seq','rtt_ms'])
 for line in lines:
  m=pattern.search(line)
  if m:w.writerow([datetime.datetime.now(datetime.timezone.utc).isoformat(),dst,int(m[1]),float(m[2])])
print(f'Parsed {sum(bool(pattern.search(l)) for l in lines)} replies into {out}')
print('Raw ping summary:')
print(''.join(lines[-5:]))
PYCODE
