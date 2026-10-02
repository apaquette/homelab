{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "smartd enabled"
    true
    config.services.smartd.enable)

  (assertEqual
    "smartd autodetection"
    false
    config.services.smartd.autodetect)

  (assertEqual
    "smartd device count"
    3
    (builtins.length config.services.smartd.devices))

  (assertEqual
    "smartd notification is declarative"
    true
    (
      builtins.match
        ".*-m <nomailer> -M exec /nix/store/.+-smartd-ntfy"
        config.services.smartd.defaults.monitored
      != null
    ))

  (assertEqual
    "smartd extraOptions unused for notification"
    []
    config.services.smartd.extraOptions)

  (assertEqual
    "smartd mail notifications disabled"
    false
    config.services.smartd.notifications.mail.enable)

  (assertEqual
    "smartd wall notifications disabled"
    false
    config.services.smartd.notifications.wall.enable)

  (assertEqual
    "smartd X11 notifications disabled"
    false
    config.services.smartd.notifications.x11.enable)

  (assertEqual
    "smartd systembus notifications disabled"
    false
    config.services.smartd.notifications.systembus-notify.enable)

  (assertEqual
    "legacy smartd script not installed"
    false
    (config.environment.etc ? "homelab/scripts/smartd-ntfy"))
]
