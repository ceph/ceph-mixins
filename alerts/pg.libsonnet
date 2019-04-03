{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'pg-alert.rules',
        rules: [
          {
            alert: 'CephPgStuck',
            expr: |||
              max(ceph_osd_numpg{%(cephExporterSelector)s}) - scalar(ceph_pg_active{%(cephExporterSelector)s}) <= 0
            ||| % $._config,
            'for': $._config.pgStuckAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Data reliability issues with storage cluster',
              description: 'Data reliability issues with storage cluster for more than %s. Recommended for admin to review the storage cluster.' % $._config.pgStuckAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          }
        ],
      },
    ],
  },
}
