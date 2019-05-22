{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ceph-mgr-status',
        rules: [
          {
            alert: 'CephMgrIsAbsent',
            expr: |||
              absent(up{%(cephExporterSelector)s} == 1)
            ||| % $._config,
            'for': $._config.mgrIsAbsentAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage metrics collector service not available anymore.',
              description: 'Ceph Manager has disappeared from Prometheus target discovery.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephMgrIsMissingReplicas',
            expr: |||
              sum(up{%(cephExporterSelector)s}) < %(cephMgrCount)d
            ||| % $._config,
            'for': $._config.mgrMissingReplicasAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: "Storage metrics collector service doesn't have required no of replicas.",
              description: 'Ceph Manager is missing replicas.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
      {
        name: 'ceph-mds-status',
        rules: [
          {
            alert: 'CephMdsMissingReplicas',
            expr: |||
              sum(ceph_mds_metadata{%(cephExporterSelector)s} == 1) < 2
            ||| % $._config,
            'for': $._config.mdsMissingReplicasAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Insufficient replicas for storage metadata service.',
              description: 'Minimum required replicas for storage metadata service not available. Might affect the working of storage cluster.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
