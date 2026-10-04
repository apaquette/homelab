{ config, helpers, ... }:

[
  # Storage-dependent native services
  (helpers.assertContains
    "Sonarr requires myraid"
    "mnt-myraid.mount"
    config.systemd.services.sonarr.requires)

  (helpers.assertContains
    "Radarr requires myraid"
    "mnt-myraid.mount"
    config.systemd.services.radarr.requires)

  (helpers.assertContains
    "qBittorrent requires myraid"
    "mnt-myraid.mount"
    config.systemd.services.qbittorrent.requires)

  # Backup failure notification handlers
  (helpers.assertContains
    "application backup notification handler"
    "homelab-backup-notify@%p.service"
    config.systemd.services.homelab-app-backup.onFailure)

  (helpers.assertContains
    "storage health notification handler"
    "homelab-storage-notify@%p.service"
    config.systemd.services.homelab-storage-health.onFailure)
]
