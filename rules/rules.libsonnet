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
      {
        name: 'telemeter.rules',
        rules: [
          {
            record: 'job:ceph_osd_in:count',
            expr: |||
              count(ceph_osd_in{%(cephExporterSelector)s} == 1)
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_up:count',
            expr: |||
              count(ceph_osd_up{%(cephExporterSelector)s} == 1)
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_metadata:count_bluestore',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s, objectstore = 'bluestore'})
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_metadata:count_filestore',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s, objectstore = 'filestore'})
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_metadata:count_ssd',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s, device_class = 'ssd'})
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_metadata:count_hdd',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s, device_class = 'hdd'})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pool_rd:total',
            expr: |||
              sum(ceph_pool_rd{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pool_wr:total',
            expr: |||
              sum(ceph_pool_wr{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pool_rd_bytes:total',
            expr: |||
              sum(ceph_pool_rd_bytes{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pool_wr_bytes:total',
            expr: |||
              sum(ceph_pool_wr_bytes{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_mds_metadata:count',
            expr: |||
              count(ceph_mds_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_mon_metadata:count',
            expr: |||
              count(ceph_mon_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_osd_metadata:count',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_mgr_metadata:count',
            expr: |||
              count(ceph_mgr_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_rgw_metadata:count',
            expr: |||
              count(ceph_rgw_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_mon_metadata:distinct',
            expr: |||
              count(count(ceph_mon_metadata{%(cephExporterSelector)s}) by (ceph_version))
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
