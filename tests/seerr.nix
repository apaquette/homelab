{ config, pkgs, helpers, ... }:

with helpers;

[
  (assertEqual
    "Seerr service enabled"
    true
    config.systemd.services.seerr.enable)

  (assertEqual
    "Seerr service user"
    "seerr"
    config.systemd.services.seerr.serviceConfig.User)

  (assertEqual
    "Seerr service group"
    "seerr"
    config.systemd.services.seerr.serviceConfig.Group)

  (assertEqual
    "Seerr working directory"
    "/opt/seerr"
    config.systemd.services.seerr.serviceConfig.WorkingDirectory)

  (assertEqual
    "Seerr environment"
    [
      "NODE_ENV=production"
      "CONFIG_DIRECTORY=/var/lib/seerr"
    ]
    config.systemd.services.seerr.serviceConfig.Environment)

  (assertEqual
    "Seerr ExecStart"
    "${pkgs.nodejs}/bin/node /opt/seerr/dist/index.js"
    config.systemd.services.seerr.serviceConfig.ExecStart)

  (assertEqual
    "Seerr restart policy"
    "on-failure"
    config.systemd.services.seerr.serviceConfig.Restart)

  (assertEqual
    "Seerr restart delay"
    5
    config.systemd.services.seerr.serviceConfig.RestartSec)

  (assertEqual
    "Seerr stop timeout"
    30
    config.systemd.services.seerr.serviceConfig.TimeoutStopSec)
]