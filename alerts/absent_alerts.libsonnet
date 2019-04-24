{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ceph-absent',
        rules: [
          {
            alert: 'CephMgrIsAbsent',
            expr: |||
              absent(up{%(cephExporterSelector)s} == 1)
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Ceph Manager has disappeared from Prometheus target discovery.',
              component: 'ceph-manager',
              grafana_url: '%(grafanaMgrDashboardURL)s' % $._config,
            },
          },
        ],
      },
      {
        name: 'ceph-down',
        rules: [
          {
            alert: 'CephMgrIsMissingReplicas',
            expr: |||
              sum(up{%(cephExporterSelector)s}) != %(cephMgrCount)d
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Ceph Manager is missing replicas.',
              component: 'ceph-manager',
              grafana_url: '%(grafanaMgrDashboardURL)s' % $._config,
            },
          },
        ],
      },
    ],
  },
}
