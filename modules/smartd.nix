{ ... }:

{
  services.smartd = {
    enable = true;
    autodetect = false;

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

    extraOptions = [
      "-M"
      "exec /etc/homelab/scripts/smartd-ntfy"
    ];
  };
}