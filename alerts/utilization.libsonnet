{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cluster-utilization-alert.rules',
        rules: [
          {
            alert: 'CephClusterNearFull',
            expr: |||
              sum(ceph_osd_stat_bytes_used) / sum(ceph_osd_stat_bytes) > 0.85
            ||| % $._config,
            'for': $._config.clusterUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage cluster is nearing full. An expansion is required',
              description: 'The utilization of storage cluster has crossed 85%.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephClusterCriticallyFull',
            expr: |||
              sum(ceph_osd_stat_bytes_used) / sum(ceph_osd_stat_bytes) > 0.95
            ||| % $._config,
            'for': $._config.clusterUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is critically full and needs immediate expansion',
              description: 'The utilization of storage cluster has crossed 95%.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
