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
    config.systemd.services.radarr.enable)

  (assertEqual
    "Radarr user"
    "radarr"
    config.systemd.services.radarr.serviceConfig.User)

  (assertEqual
    "Radarr group"
    "radarr"
    config.systemd.services.radarr.serviceConfig.Group)

  (assertEqual
    "Radarr state directory"
    "/var/lib/radarr"
    (builtins.elemAt
      (builtins.match ".*-data=([^ ]+).*" config.systemd.services.radarr.serviceConfig.ExecStart)
      0))

  # Prowlarr
  (assertEqual
    "Prowlarr service enabled"
    true
    config.systemd.services.prowlarr.enable)

  (assertEqual
    "Prowlarr user"
    "prowlarr"
    config.systemd.services.prowlarr.serviceConfig.User)

  (assertEqual
    "Prowlarr group"
    "prowlarr"
    config.systemd.services.prowlarr.serviceConfig.Group)

  (assertEqual
    "Prowlarr state directory"
    "/var/lib/prowlarr"
    (builtins.elemAt
      (builtins.match ".*-data=([^ ]+).*" config.systemd.services.prowlarr.serviceConfig.ExecStart)
      0))

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
