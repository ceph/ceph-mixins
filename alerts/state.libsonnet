{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'state-alert.rules',
        rules: [
          {
            alert: 'OCS_CephClusterErrorState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} > 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Ceph cluster is in error state',
            },
          },
          {
            alert: 'OCS_CephClusterWarningState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} == 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Ceph cluster is in warning state',
            },
          },
        ],
      },
    ],
  },
}
