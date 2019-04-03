{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'network-alert.rules',
        rules: [
          {
            alert: 'NetworkError',
            expr: |||
              label_replace(node_network_transmit_errs_total, "host", "$1", "instance", "(.*):.*") > 0 or label_replace(node_network_receive_errs_total, "host", "$1", "instance", "(.*):.*") > 0
            ||| % $._config,
            'for': $._config.networkErrorAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Network card showing send/receive errors on host {{ $labels.host }}',
              description: 'Interface {{ $labels.device }} on host {{ $labels.host }} has errors. Please check cabling and network switch logs',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'NetworkInterfaceDown',
            expr: |||
              label_replace(node_network_up{interface=~"(eth|en|bond|ib|mlx).*"}, "host", "$1", "instance", "(.*):.*") == 0
            ||| % $._config,
            'for': $._config.networkInterfaceErrorAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Network interface is down on {{ $labels.host }}',
              description: 'Interface {{ $labels.interface }} on host {{ $labels.host }} is down. Please check cabling, and network switch logs',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'NetworkInterfaceFlapping',
            expr: |||
              label_replace(changes(node_network_up[30s]), "host", "$1","instance","(.*):.*") > 2
            ||| % $._config,
            'for': $._config.networkInterfaceErrorAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Network interface flapping on host {{ $labels.host }}',
              description: 'Interface {{ $labels.interface }} on {{ $labels.host }} is changing state (up/down) too often',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
