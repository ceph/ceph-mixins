{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cluster-state-alert.rules',
        rules: [
          {
            alert: 'CephClusterErrorState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} > 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is in error state',
              description: 'Storage cluster is in error state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephClusterWarningState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} == 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage cluster is in warning state',
              description: 'Storage cluster is in warning state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
