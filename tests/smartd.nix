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
    "smartd notification command"
    [ "-M" "exec /etc/homelab/scripts/smartd-ntfy" ]
    config.services.smartd.extraOptions)
]