{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'osd-alert.rules',
        rules: [
          {
            alert: 'CephOSDDiskNotResponding',
            expr: |||
              label_replace((ceph_osd_in{%(cephExporterSelector)s} == 1 and ceph_osd_up{%(cephExporterSelector)s} == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation{%(cephExporterSelector)s},"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Disk not responding',
              description: 'Disk device {{ $labels.device }} not responding, on host {{ $labels.host }}.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephOSDDiskUnavailable',
            expr: |||
              label_replace((ceph_osd_in{%(cephExporterSelector)s} == 0 and ceph_osd_up{%(cephExporterSelector)s} == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation{%(cephExporterSelector)s},"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Disk not accessible',
              description: 'Disk device {{ $labels.device }} not accessible on host {{ $labels.host }}.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephDataRecoveryTakingTooLong',
            expr: |||
              ceph_pg_undersized{%(cephExporterSelector)s} > 0
            ||| % $._config,
            'for': $._config.osdDataRecoveryAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Data recovery is slow',
              description: 'Data recovery has been active for more than %s. Contact Support.' % $._config.osdDataRecoveryAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephPGRepairTakingTooLong',
            expr: |||
              ceph_pg_inconsistent{%(cephExporterSelector)s} > 0
            ||| % $._config,
            'for': $._config.PGRepairAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Self heal problems detected',
              description: 'Self heal operations taking too long. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDLowSpace',
            expr: |||
              (ceph_osd_stat_bytes_used{%(cephExporterSelector)s} / ceph_osd_stat_bytes{%(cephExporterSelector)s}) * 100 > 85
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: '{{$labels.ceph_daemon}} Ceph OSD used more than 85 % of disk space.',
            },
          },
        ],
      },
    ],
  },
}
