{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'quorum-alert.rules',
        rules: [
          {
            alert: 'MonQuorumAtRisk',
            expr: |||
              count(ceph_mon_quorum_status == 1) <= ((count(ceph_mon_metadata) %s 2) + 1)
            ||| % '%',
            'for': $._config.monQuorumAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage quorum at risk',
              description: 'Quorum is low for storage cluster. Please Contact Support',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
