{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "container health timer interval"
    "15min"
    config.systemd.timers.homelab-container-health.timerConfig.OnUnitActiveSec)

  (assertEqual
    "disk health timer interval"
    "15min"
    config.systemd.timers.homelab-disk-health.timerConfig.OnUnitActiveSec)

  (assertEqual
    "storage health timer interval"
    "15min"
    config.systemd.timers.homelab-storage-health.timerConfig.OnUnitActiveSec)

  (assertEqual
    "storage health failure notification"
    [ "homelab-storage-notify@%p.service" ]
    config.systemd.services.homelab-storage-health.onFailure)

  (assertEqual
    "backup failure notification"
    [ "homelab-backup-notify@%p.service" ]
    config.systemd.services.homelab-app-backup.onFailure)
]