{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    cephExporterSelector: 'job="rook-ceph-mgr"',

    // Duration to raise various Alerts
    absentRookCephMgrAlertTime: '5s',
    cephNodeDownAlertTime: '30s',
    clusterStateAlertTime: '10m',
    clusterVersionAlertTime: '10m',
    clusterUtilizationAlertTime: '5m',
    monQuorumAlertTime: '15m',
    osdDataRebalanceAlertTime: '15s',
    osdDataRecoveryAlertTime: '2h',
    osdDataRecoveryInProgressAlertTime: '30s',
    osdDiskAlertTime: '1m',
    osdDownAlertTime: '5m',
    PGRepairAlertTime: '1h',

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
