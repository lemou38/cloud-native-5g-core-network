#!/usr/bin/env bash
set -uo pipefail
printf '== Host ==\n'; uname -a; (lsb_release -ds || true)
printf '\n== Memory / CPU / disk ==\n'; free -h; nproc; df -h .
printf '\n== Commands ==\n'
for x in git docker python3 ip iperf3 tcpdump tshark; do if command -v "$x" >/dev/null; then echo "OK $x"; else echo "MISSING $x"; fi; done
printf '\n== Docker compose ==\n'; docker compose version 2>&1 || true
printf '\n== SCTP / TUN / forwarding ==\n'
if [[ -e /dev/net/tun ]]; then echo 'TUN device exists'; else echo 'TUN device missing'; fi
lsmod | grep -E '^sctp ' || echo 'SCTP not currently loaded (may need sudo modprobe sctp)'
sysctl net.ipv4.ip_forward 2>/dev/null || true
printf '\nCheck Docker privileges and host firewall before deployment.\n'
