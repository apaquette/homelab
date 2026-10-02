{ config, pkgs, helpers, ... }:

with helpers;

[
  (assertEqual
    "Seerr service enabled"
    true
    config.services.seerr.enable)

  (assertEqual
    "Seerr package"
    pkgs.seerr
    config.services.seerr.package)

  (assertEqual
    "Seerr port"
    5055
    config.services.seerr.port)

  (assertEqual
    "Seerr config directory"
    "/var/lib/seerr"
    config.services.seerr.configDir)

  (assertEqual
    "Seerr firewall disabled"
    false
    config.services.seerr.openFirewall)

  (assertEqual
    "Seerr uses dynamic user"
    true
    config.systemd.services.seerr.serviceConfig.DynamicUser)

  (assertEqual
    "Seerr state directory"
    "seerr"
    config.systemd.services.seerr.serviceConfig.StateDirectory)

  (assertEqual
    "Seerr requires config mount"
    [ "/var/lib/seerr" ]
    config.systemd.services.seerr.unitConfig.RequiresMountsFor)
]
