{ config, helpers, ... }:

with helpers;

[
  # Sonarr
  (assertEqual
    "Sonarr service enabled"
    true
    config.services.sonarr.enable)

  (assertEqual
    "Sonarr user"
    "sonarr"
    config.services.sonarr.user)

  (assertEqual
    "Sonarr group"
    "sonarr"
    config.services.sonarr.group)

  (assertEqual
    "Sonarr state directory"
    "/var/lib/sonarr"
    config.services.sonarr.dataDir)

  (assertEqual
    "Sonarr media user access"
    true
    (builtins.elem
      "apaquette"
      config.users.users.sonarr.extraGroups))

  # Radarr
  (assertEqual
    "Radarr service enabled"
    true
    config.services.radarr.enable)

  (assertEqual
    "Radarr user"
    "radarr"
    config.services.radarr.user)

  (assertEqual
    "Radarr group"
    "radarr"
    config.services.radarr.group)

  (assertEqual
    "Radarr state directory"
    "/var/lib/radarr"
    config.services.radarr.dataDir)

  (assertEqual
    "Radarr media user access"
    true
    (builtins.elem
      "apaquette"
      config.users.users.radarr.extraGroups))

  # Prowlarr
  (assertEqual
    "Prowlarr service enabled"
    true
    config.services.prowlarr.enable)

  (assertEqual
    "Prowlarr state directory"
    "/var/lib/prowlarr"
    config.services.prowlarr.dataDir)

  # qBittorrent
  (assertEqual
    "qBittorrent service enabled"
    true
    config.systemd.services.qbittorrent-nox.enable)

  (assertEqual
    "qBittorrent user"
    "qbittorrent"
    config.systemd.services.qbittorrent-nox.serviceConfig.User)

  (assertEqual
    "qBittorrent group"
    "qbittorrent"
    config.systemd.services.qbittorrent-nox.serviceConfig.Group)
]
