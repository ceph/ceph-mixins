{
  prometheusRules+:: {
    groups+: [
      {
        name: 'ceph.rules',
        rules: [
          {
            record: 'ceph_node_down',
            expr: |||
              kube_node_status_condition{condition="Ready",job="kube-state-metrics",status="true"} * on (node) group_right() max(label_replace(ceph_disk_occupation,"node","$1","exported_instance","(.*)")) by (node) == 0
            ||| % $._config,
          }
        ],
      },
    ],
  },
}
