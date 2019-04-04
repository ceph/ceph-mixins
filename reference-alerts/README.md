# Reference Alert Rules  
The alert-rules.yml file contains a set of reference alert triggers for Ceph - primarily focussed on the k8s use case where the alerts are intended to reflect actionable events rather than normal low level Ceph activity.  

The alerts include the following;

| Name | Description |  
|------|-------------|  
| Health OK | ceph health is OK (0) |   
| Health Warning | ceph health is in warning state (1) |    
| Health Error | ceph health is in an error state (2) |  
| OSD Host Down | Check for up state across hosts carrying OSDs |   
| Capacity check for node outage | Looks for most full host, and checks against freespace in the cluster  | 
| Capacity running low | Capacity > 85% full |  
| Ceph versions inconsistent (MDS) | MDS daemon version checked |  
| Ceph versions inconsistent (MON) | MON daemon version check |  
| Ceph versions inconsistent (OSD) | OSD daemon version check - these could vary as a new image is rolled out, so the check time is long |    
| Check clock skew | Use the exporter's ntp plugin to check for clock skew. Mon's tolerate up to 0.05s skew |   
| Data rebalance queued | pg is flagged for remapping, typically new disk or osd down but not out |  
| Data rebalance active | Remapping pgs is active (e.g. the remapped counter is changing) |   
| Data recovery active | Data is being resync'd (e.g. undersized pg counter is changing) |  
| Data recovery queued | The pg undersized counter is > 0, but it's not moving |   
| Data recovery taking too long | Check to see if with have pg_undersized active for too long |   
| Disk Connectivity (down) | osd is down, but still in - stays in this state until out interval reached |  
| Disk Unavailable (down + out) | Disk is inaccessible (down and timeout interval reached marking it out) |  
| Free capacity approaching critical | Capacity at or above 95% |  
| Mon quorum at risk | Alert if the number of mons is at risk of losing quorum |  
| Network transmit/receive errors | NIC is showing errors - potential cable issue. Performance impact likely |  
| Network port down | NIC port is in a down state |   
| Network port flapping | NIC port has changed state multiple times in a short period |  
| PGs repair taking too long | PGs repair should be automatic - if we still see inconsistent pgs after 1hr, there's a problem |  
| PGs too high | PGs per OSD is too high. this can impact memory, peering and increase cpu load on the mon/mgr |
| Self heal disabled | noout and nodown flags have been set for too long |   

You can use the alerts defined in ```alert-rules.yml``` in a standalone ceph/prometheus environment or use the ```prometheus-ceph-rules.yml``` file when testing against rook/ceph+prometheus.


