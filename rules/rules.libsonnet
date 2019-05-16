{
  prometheusRules+:: {
    groups+: [
      {
        name: 'ceph.rules',
        rules: [
          {
            record: 'cluster:ceph_node_down:join_kube',
            expr: |||
              kube_node_status_condition{condition="Ready",job="kube-state-metrics",status="true"} * on (node) group_right() max(label_replace(ceph_disk_occupation{%(cephExporterSelector)s},"node","$1","exported_instance","(.*)")) by (node)
            ||| % $._config,
          },
          {
            record: 'cluster:ceph_disk_latency:join_ceph_node_disk_irate1m',
            expr: |||
              (sum((max(label_replace(ceph_disk_occupation{%(cephExporterSelector)s},"node","$1","exported_instance","(.*)")) by (node)) * on (node) group_right() (label_replace(max by(pod_ip,node) (kube_pod_info{pod=~"node-exporter.*"}), "instance", "$1:9100", "pod_ip", "(.*)"))  * on (instance) group_right() (irate(node_disk_read_time_seconds_total[1m]) + irate(node_disk_write_time_seconds_total[1m]) /  (irate(node_disk_reads_completed_total[1m]) + irate(node_disk_writes_completed_total[1m]))>0)))
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
