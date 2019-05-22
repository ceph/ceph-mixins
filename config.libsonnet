{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    cephExporterSelector: 'job="rook-ceph-mgr"',

    // Expected number of Ceph Managers which are reporting metrics
    cephMgrCount: 1,

    // Duration to raise various Alerts
    cephNodeDownAlertTime: '30s',
    clusterStateAlertTime: '10m',
    clusterVersionAlertTime: '10m',
    clusterUtilizationAlertTime: '5m',
    monQuorumAlertTime: '15m',
    monQuorumLeaderChangesAlertTime: '5m',
    osdDataRebalanceAlertTime: '15s',
    osdDataRecoveryAlertTime: '2h',
    osdDataRecoveryInProgressAlertTime: '30s',
    osdDiskAlertTime: '1m',
    osdDownAlertTime: '5m',
    PGRepairAlertTime: '1h',
    mgrMissingReplicasAlertTime: '5m',
    mgrIsAbsentAlertTime: '5m',
    mdsMissingReplicasAlertTime: '5m',

    // Constants
    storageType: 'ceph',

    // For links between grafana dashboards, you need to tell us if your grafana
    // servers under some non-root path.
    grafanaPrefix: '',

    // We build alerts for the presence of all these jobs.
    jobs: {
      CephExporter: $._config.cephExporterSelector,
    },
  },
}
