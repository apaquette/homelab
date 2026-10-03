{ config, pkgs, helpers, ... }:

with helpers;

[
  (assertEqual
    "uptime-kuma enabled"
    true
    config.services.uptime-kuma.enable)

  (assertEqual
    "uptime-kuma package"
    pkgs.uptime-kuma
    config.services.uptime-kuma.package)

  (assertEqual
    "uptime-kuma version"
    "2.5.5"
    config.services.uptime-kuma.package.version)

  (assertEqual
    "uptime-kuma data directory"
    "/var/lib/uptime-kuma/"
    config.services.uptime-kuma.settings.DATA_DIR)

  (assertEqual
    "uptime-kuma host"
    "127.0.0.1"
    config.services.uptime-kuma.settings.HOST)

  (assertEqual
    "uptime-kuma port"
    "3001"
    config.services.uptime-kuma.settings.PORT)

  (assertEqual
    "uptime-kuma database type"
    "sqlite"
    config.services.uptime-kuma.settings.UPTIME_KUMA_DB_TYPE)

  (assertEqual
    "uptime-kuma extra CA certificates"
    config.security.pki.caBundle
    config.services.uptime-kuma.settings.NODE_EXTRA_CA_CERTS)

  (assertEqual
    "uptime-kuma StateDirectory"
    "uptime-kuma"
    config.systemd.services.uptime-kuma.serviceConfig.StateDirectory)

  (assertEqual
    "uptime-kuma StateDirectoryMode"
    "750"
    config.systemd.services.uptime-kuma.serviceConfig.StateDirectoryMode)

  (assertEqual
    "uptime-kuma DynamicUser"
    true
    config.systemd.services.uptime-kuma.serviceConfig.DynamicUser)

  (assertEqual
    "uptime-kuma ExecStart"
    "${pkgs.uptime-kuma}/bin/uptime-kuma-server"
    config.systemd.services.uptime-kuma.serviceConfig.ExecStart)

  (assertEqual
    "uptime-kuma Restart"
    "on-failure"
    config.systemd.services.uptime-kuma.serviceConfig.Restart)

  (assertContains
    "uptime-kuma wantedBy"
    "multi-user.target"
    config.systemd.services.uptime-kuma.wantedBy)

  (assertContains
    "uptime-kuma after"
    "network.target"
    config.systemd.services.uptime-kuma.after)
]
