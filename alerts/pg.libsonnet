{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'pg-alert.rules',
        rules: [
          {
            alert: 'OCS_CephPgStuck',
            expr: |||
              max(ceph_osd_numpg{%(cephExporterSelector)s}) - scalar(ceph_pg_active{%(cephExporterSelector)s}) <= 0
            ||| % $._config,
            'for': $._config.pgStuckAlertTime,
            labels: {
              severity: 'error',
            },
            annotations: {
              message: 'OCS Ceph PG\'s in stuck state. Recommended for Admin to review the cluster.',
            },
          }
        ],
      },
    ],
  },
}
