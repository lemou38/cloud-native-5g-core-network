# 5G protocol analysis

- **N1 / NAS-5GS:** UE registration, authentication, security and session signaling (carried through gNB).
- **N2 / NGAP:** gNB-to-AMF control-plane signaling over SCTP (often port 38412).
- **N3 / GTP-U:** gNB-to-UPF user-plane tunnel (UDP 2152).
- **N4 / PFCP:** SMF-to-UPF session control (UDP 8805).
- **N6:** UPF to data network.

## Capture examples

```bash
sudo tcpdump -i any -s 0 -w results/5g-lab.pcapng 'sctp or udp port 2152 or udp port 8805'
bash scripts/analyze_pcap.sh results/5g-lab.pcapng results/protocols.tsv
```

Capture may need to run in a container network namespace or on the correct bridge interface. `any` can have encapsulation limitations; confirm packets are visible. NAS payloads may be ciphered after security activation. Filter and export only information you are authorized to collect.
