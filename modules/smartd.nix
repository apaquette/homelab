{ ... }:

{
  services.smartd = {
    enable = true;

    autodetect = false;

    devices = [
      {
        device = "/dev/disk/by-id/ata-ST4000NE001-2MA101_WS258JW7";
      }

      {
        device = "/dev/disk/by-id/ata-ST4000NE001-2MA101_WS258JKS";
      }

      {
        device = "/dev/disk/by-id/usb-Seagate_Expansion_NA876FG1-0:0";
      }
    ];

    extraOptions = [
      "-M"
      "exec /etc/homelab/scripts/smartd-ntfy"
    ];
  };
}