# Deployment runbook

## 1. Host

Use a Linux VM with at least 4 vCPU, 8 GiB RAM and 40 GiB disk (recommended lab sizing, not vendor minimum). Enable virtualization and Internet access. Install Docker Engine + Docker Compose plugin from the official Docker Ubuntu documentation: https://docs.docker.com/engine/install/ubuntu/ .

## 2. Inspect prerequisites

```bash
bash scripts/preflight.sh
sudo modprobe sctp
```

Docker access may require `sudo` or membership in the `docker` group (which grants root-equivalent privileges). Do not publish credentials.

## 3. Fetch upstream deployment

```bash
bash scripts/bootstrap.sh
cd vendor/docker_open5gs
```

Read the **current upstream README** and select its documented **5G SA + UERANSIM** Compose configuration. Inspect the compose files and environment variables before launch. **No specific upstream compose filename or command is guaranteed by this repository.** The upstream implementation is a third-party dependency, not code authored here.

## 4. Configure and launch

Set consistent MCC/MNC, TAC, gNB/AMF addresses, DNN/APN, slice values, and UE subscriber credentials in the selected upstream profile. Launch only using the upstream-documented commands. Ensure required Linux TUN and SCTP features are available. For test IMSI/keys, use only lab values; never use production subscriber credentials.

## 5. Evidence checklist

- `docker compose ps` shows healthy core services (where healthchecks are implemented).
- AMF logs show gNB association and UE registration.
- Subscriber profile is present and matches UE configuration.
- SMF/UPF logs show successful PDU session establishment.
- UE tunnel interface and route exist.
- Ping/iperf3 tests **from the UE data path** reach a controlled destination.
- pcap shows NGAP/NAS control-plane messages and N3 GTP-U traffic.

Capture timestamps, command output, upstream commit SHA and redacted logs. If any step fails, report the failure rather than claiming success.

## 6. Optional cloud-native extension

A Docker Compose lab demonstrates containerization. To substantiate a Kubernetes/cloud-native claim, deploy and test independently using a suitable maintained 5G Helm/Kubernetes implementation, then record rollout, restart, resource and recovery evidence.
