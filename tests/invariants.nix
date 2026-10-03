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

  # Storage-dependent Compose services
  (helpers.assertContains
    "Nextcloud Compose requires myraid"
    "mnt-myraid.mount"
    config.systemd.services.nextcloud-compose.requires)

  (helpers.assertContains
    "Immich Compose requires myraid"
    "mnt-myraid.mount"
    config.systemd.services.immich-compose.requires)

  (helpers.assertContains
    "Beszel Compose requires backup"
    "mnt-backup.mount"
    config.systemd.services.beszel-compose.requires)

  # Docker Compose services require Docker
  (helpers.assertContains
    "Nextcloud Compose requires Docker"
    "docker.service"
    config.systemd.services.nextcloud-compose.requires)

  (helpers.assertContains
    "Immich Compose requires Docker"
    "docker.service"
    config.systemd.services.immich-compose.requires)

  (helpers.assertContains
    "Beszel Compose requires Docker"
    "docker.service"
    config.systemd.services.beszel-compose.requires)

  (helpers.assertContains
    "Jenkins Compose requires Docker"
    "docker.service"
    config.systemd.services.jenkins-compose.requires)

  # Backup failure notification handlers
  (helpers.assertContains
    "application backup notification handler"
    "homelab-backup-notify@%p.service"
    config.systemd.services.homelab-app-backup.onFailure)

  (helpers.assertContains
    "storage health notification handler"
    "homelab-storage-notify@%p.service"
    config.systemd.services.homelab-storage-health.onFailure)

  # SOPS templates consumed by Compose services
  (helpers.assertEqual
    "Nextcloud Compose SOPS template"
    config.sops.templates."nextcloud.env".path
    config.systemd.services.nextcloud-compose.serviceConfig.EnvironmentFile)

  (helpers.assertEqual
    "Immich Compose SOPS template"
    config.sops.templates."immich.env".path
    config.systemd.services.immich-compose.serviceConfig.EnvironmentFile)

  (helpers.assertEqual
    "Beszel Compose SOPS template"
    config.sops.templates."beszel.env".path
    config.systemd.services.beszel-compose.serviceConfig.EnvironmentFile)
]
