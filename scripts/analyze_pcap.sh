#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then echo 'Usage: analyze_pcap.sh CAPTURE.pcapng OUTPUT.tsv' >&2; exit 2; fi
command -v tshark >/dev/null || { echo 'Install tshark' >&2; exit 1; }
mkdir -p "$(dirname "$2")"
tshark -r "$1" -Y 'ngap || nas-5gs || pfcp || gtp' -T fields -E header=y -E separator=/t \
 -e frame.number -e frame.time_relative -e _ws.col.Protocol -e ip.src -e ip.dst \
 -e ngap.procedureCode -e pfcp.msg_type > "$2"
echo "Wrote protocol observations to $2. Field availability varies by tshark version."
