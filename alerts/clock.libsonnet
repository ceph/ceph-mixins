{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'clock-alert.rules',
        rules: [
          {
            alert: 'ClockSkew',
            expr: |||
              label_replace((node_ntp_offset_seconds < -0.03 or node_ntp_offset_seconds > 0.03),"host","$1","instance","(.*):.*")
            ||| % $._config,
            'for': $._config.clockSkewAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Clock skew/drift detected',
              description: 'Clock skew detected on {{ $labels.host }}. Please confirm NTP is configured correctly on this host',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
