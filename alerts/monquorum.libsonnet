{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'quorum-alert.rules',
        rules: [
          {
            alert: 'CephMonQuorumAtRisk',
            expr: |||
              count(ceph_mon_quorum_status == 1) <= ((count(ceph_mon_metadata) %s 2) + 1)
            ||| % '%',
            'for': $._config.monQuorumAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage quorum at risk',
              description: 'Storage cluster quorum is low. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
