#!/usr/bin/env python3
"""Analyze measured ICMP RTT and optional iperf3 JSON; no synthetic results."""
import argparse,csv,json,statistics,math
from pathlib import Path

def summarize_ping(path, expected=None):
    with open(path,newline='',encoding='utf-8') as f:
        rows=list(csv.DictReader(f))
    vals=[float(r['rtt_ms']) for r in rows if r.get('rtt_ms')]
    if not vals: raise ValueError('No ICMP replies found: check tunnel and capture')
    out={'received':len(vals),'rtt_min_ms':min(vals),'rtt_mean_ms':statistics.mean(vals),
         'rtt_median_ms':statistics.median(vals),'rtt_max_ms':max(vals),
         'rtt_p95_ms':sorted(vals)[max(0, math.ceil(.95*len(vals))-1)]}
    if expected is not None:
        if expected < len(vals): raise ValueError('Expected count below received count')
        out.update(sent=expected,packet_loss_percent=round(100*(expected-len(vals))/expected,2))
    return out

def summarize_iperf(path):
    data=json.loads(Path(path).read_text(encoding='utf-8'))
    end=data.get('end',{})
    result=end.get('sum_received') or end.get('sum') or end.get('sum_sent')
    if not result or 'bits_per_second' not in result: raise ValueError('Missing iperf3 throughput data')
    return {'throughput_mbps':result['bits_per_second']/1e6,'duration_seconds':result.get('seconds')}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--ping');ap.add_argument('--sent',type=int)
    ap.add_argument('--iperf');ap.add_argument('--out',default='results/summary.json');a=ap.parse_args()
    if not a.ping and not a.iperf: ap.error('Provide --ping and/or --iperf')
    if a.sent is not None and a.sent <= 0: ap.error('--sent must be positive')
    data={'measurement_status':'measured'}
    if a.ping:data['ping']=summarize_ping(a.ping,a.sent)
    if a.iperf:data['iperf3']=summarize_iperf(a.iperf)
    Path(a.out).parent.mkdir(parents=True,exist_ok=True)
    Path(a.out).write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(data,indent=2))
if __name__=='__main__':main()
