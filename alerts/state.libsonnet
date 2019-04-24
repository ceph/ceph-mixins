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
              message: 'Storage cluster is in degraded state',
              description: 'Storage cluster is in warning state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDVersionMismatch',
            expr: |||
              count(count(ceph_osd_metadata{%(cephExporterSelector)s}) by (ceph_version)) > 1
            ||| % $._config,
            'for': '1h',
            labels: {
              'for': $._config.clusterVersionAlertTime,
            },
            annotations: {
              message: 'There are {{ $value }} different versions of Ceph OSD components running.',
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephMonVersionMismatch',
            expr: |||
              count(count(ceph_mon_metadata{%(cephExporterSelector)s}) by (ceph_version)) > 1
            ||| % $._config,
            'for': $._config.clusterVersionAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'There are {{ $value }} different versions of Ceph Mon components running.',
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
