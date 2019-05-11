{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'quorum-alert.rules',
        rules: [
          {
            alert: 'CephMonQuorumAtRisk',
            expr: |||
              count(ceph_mon_quorum_status{%s} == 1) <= ((count(ceph_mon_metadata{%s}) %s 2) + 1)
            ||| % [$._config.cephExporterSelector, $._config.cephExporterSelector, '%'],
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
          {
            alert: 'CephMonHighNumberOfLeaderChanges',
            expr: |||
              rate(ceph_mon_num_elections{%(cephExporterSelector)s}[15m]) > 3
            ||| % $._config,
            'for': $._config.monQuorumLeaderChangesAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage Cluster has seen many leader changes recently.',
              description: 'Ceph Monitor "{{ $labels.job }}": instance {{ $labels.instance }} has seen {{ $value }} leader changes recently.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
