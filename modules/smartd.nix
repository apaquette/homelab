{ config, pkgs, ... }:

let
  smartdNtfy = pkgs.writeShellScript "smartd-ntfy" ''
    set -euo pipefail

    NTFY_URL="https://ntfy.alexpaquette.dev/homelab-smart"
    TOKEN_FILE="${config.sops.secrets."smartd-ntfy-token".path}"

    MESSAGE="''${SMARTD_MESSAGE:-}"
    DEVICE="''${SMARTD_DEVICE:-unknown}"

    if [ -z "$MESSAGE" ]; then
      MESSAGE="SMART notification for $DEVICE"
    fi

    TOKEN=$(<"$TOKEN_FILE")

    exec ${pkgs.curl}/bin/curl -fsS \
      --max-time 15 \
      -H "Authorization: Bearer $TOKEN" \
      -H "Title: SMART Alert — $DEVICE" \
      -H "Priority: high" \
      -H "Tags: warning,computer" \
      -d "$MESSAGE" \
      -o /dev/null \
      "$NTFY_URL"
  '';
in
{
  services.smartd = {
    enable = true;
    autodetect = false;

    defaults.monitored = "-a -m <nomailer> -M exec ${smartdNtfy}";

    notifications = {
      mail.enable = false;
      systembus-notify.enable = false;
      wall.enable = false;
      x11.enable = false;
      test = false;
    };

    devices = [
      {
        device = "/dev/disk/by-id/ata-ST4000NE001-2MA101_WS258JW7";
        options = "-d sat";
      }
      {
        device = "/dev/disk/by-id/ata-ST4000NE001-2MA101_WS258JKS";
        options = "-d sat";
      }
      {
        device = "/dev/disk/by-id/nvme-SKHynix_HFS512GD9TNG-L5B0B_ND02N6624135Y2S5E";
        options = "-d nvme";
      }
    ];
  };
}
