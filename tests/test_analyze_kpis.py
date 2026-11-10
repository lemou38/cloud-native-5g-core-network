import sys,tempfile,unittest,csv,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from analyze_kpis import summarize_ping,summarize_iperf

class TestKPIs(unittest.TestCase):
    def test_ping(self):
        with tempfile.TemporaryDirectory() as d:
            p=Path(d)/'p.csv'
            with p.open('w',newline='') as f:
                w=csv.writer(f);w.writerow(['timestamp_utc','destination','icmp_seq','rtt_ms'])
                w.writerows([['x','a',i,n] for i,n in enumerate([10,20,30],1)])
            s=summarize_ping(p,4)
            self.assertEqual(s['rtt_mean_ms'],20)
            self.assertEqual(s['packet_loss_percent'],25)
    def test_iperf(self):
        with tempfile.TemporaryDirectory() as d:
            p=Path(d)/'iperf.json';p.write_text(json.dumps({'end':{'sum_received':{'bits_per_second':12000000,'seconds':10}}}))
            self.assertEqual(summarize_iperf(p)['throughput_mbps'],12)
if __name__=='__main__':unittest.main()
