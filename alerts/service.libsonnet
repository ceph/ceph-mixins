{
  local prometheusAlertsObj = {
    groups+: [
      {
        name: 'service.rules',
        rules: [
          {
            alert: 'AbsentRookCephMgr',
            expr: |||
              absent(up{%(cephExporterSelector)s,pod=~"rook-ceph-mgr-(.*)",service="rook-ceph-mgr"})==1
            ||| % $._config,
            'for': $._config.absentRookCephMgrAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Rook-ceph-mgr service not present.',
              description: 'Rook-ceph-mgr service not present. Please check the deployment.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
  prometheusAlerts+:: if $._config.alertAbsentRookCephMgr then prometheusAlertsObj else {},
}

