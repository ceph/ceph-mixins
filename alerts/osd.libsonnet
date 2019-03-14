{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'osd-alert.rules',
        rules: [
          {
            alert: 'CephOSDsDown',
            expr: |||
              (count(ceph_osd_up * on(ceph_daemon) ceph_osd_in == 0) > 0) and ((ceph_pg_total - on(job) ceph_pg_clean) > 0)
            ||| % $._config,
            'for': $._config.osdDownAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Additional load recovery places on ceph cluster. Client IO could be affected.',
              description: 'Additional load recovery places on ceph cluster. Client IO could be affected.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDDiskNotResponding',
            expr: |||
              label_replace((ceph_osd_in == 1 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Disk not responding',
              description: 'Disk not responding, on host {{ $labels.host }} (device {{ $labels.device }})',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDDiskUnavailable',
            expr: |||
              label_replace((ceph_osd_in == 0 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Disk is inaccessible',
              description: 'Disk inaccessible on host {{ $labels.host }} (device {{ $labels.device }})',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephDataRecoveryActive',
            expr: |||
              rate(ceph_pg_undersized[30s]) > 0 and ceph_pg_undersized > 0
            ||| % $._config,
            'for': $._config.osdDataRecoveryInProgressAlertTime,
            labels: {
              severity: 'info',
            },
            annotations: {
              message: 'Data recovery is active',
              description: 'Data recovery is active, resynchronizing data to the required data protection level',
              storage_type: $._config.storageType,
              severity_level: 'info',
            },
          },
          {
            alert: 'CephDataRecoveryQueued',
            expr: |||
              rate(ceph_pg_undersized[30s]) == 0 and ceph_pg_undersized > 0
            ||| % $._config,
            'for': $._config.osdDataRecoveryInProgressAlertTime,
            labels: {
              severity: 'info',
            },
            annotations: {
              message: 'Data recovery is queued',
              description: 'Data recovery is queued',
              storage_type: $._config.storageType,
              severity_level: 'info',
            },
          },
          {
            alert: 'CephDataRecoveryTakingTooLong',
            expr: |||
              ceph_pg_undersized > 0
            ||| % $._config,
            'for': $._config.osdDataRecoveryAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Data recovery is slow',
              description: 'Data recovery has been active for over %s. Contact Support' % $._config.osdDataRecoveryAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephDataRebalanceQueued',
            expr: |||
              rate(ceph_pg_remapped[30s]) == 0 and ceph_pg_remapped > 0 and ceph_pg_undersized == 0
            ||| % $._config,
            'for': $._config.osdDataRebalanceAlertTime,
            labels: {
              severity: 'info',
            },
            annotations: {
              message: 'Data rebalance queued',
              description: 'Data rebalance is queued (rebalance improves disk utilization and performance)',
              storage_type: $._config.storageType,
              severity_level: 'info',
            },
          },
          {
            alert: 'CephDataRebalanceActive',
            expr: |||
              rate(ceph_pg_remapped[30s]) > 0 and ceph_pg_remapped > 0 and ceph_pg_undersized == 0
            ||| % $._config,
            'for': $._config.osdDataRebalanceAlertTime,
            labels: {
              severity: 'info',
            },
            annotations: {
              message: 'Data rebalance active',
              description: 'Data rebalance is active (rebalance improves disk utilization and performance)',
              storage_type: $._config.storageType,
              severity_level: 'info',
            },
          },
          {
            alert: 'CephPGRepairTakingTooLong',
            expr: |||
              ceph_pg_inconsistent > 0
            ||| % $._config,
            'for': $._config.PGRepairAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Problems detected within self heal',
              description: 'Self Heal operations taking too long. Contact Support',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
