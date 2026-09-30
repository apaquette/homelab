{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "application backup schedule"
    "*-*-* 04:00:00"
    config.systemd.timers.homelab-app-backup.timerConfig.OnCalendar)

  (assertEqual
    "Nextcloud backup schedule"
    "*-*-* 02:30:00"
    config.systemd.timers.nextcloud-backup.timerConfig.OnCalendar)

  (assertEqual
    "Immich backup schedule"
    "*-*-* 03:00:00"
    config.systemd.timers.immich-backup.timerConfig.OnCalendar)
]