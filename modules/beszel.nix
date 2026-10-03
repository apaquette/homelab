{ config,lib, unstable, ... }:

{
  services.beszel.hub = {
    enable = true;
    package = unstable.beszel;
    host = "127.0.0.1";
    port = 8090;
    dataDir = "/var/lib/beszel-hub";

    environment = {
      APP_URL = "https://beszel.alexpaquette.dev";
    };
  };

  systemd.services.beszel-hub.serviceConfig.ExecStartPre = lib.mkForce [
    "${unstable.beszel}/bin/beszel-hub migrate up"
  ];

services.beszel.agent = {
  enable = true;
  package = unstable.beszel;

  environment = {
    DATA_DIR = "/var/lib/beszel-agent";
    LISTEN = "45876";
    KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDTGvwZ3qofUZxq9cVmeVz0n9dfA9IRHwxyYvyLyboP";
    HUB_URL = "http://127.0.0.1:8090";
    EXTRA_FILESYSTEMS =
      "/mnt/backup__Backup_Storage,/mnt/myraid__RAID_Storage__";
  };

  environmentFile = config.sops.templates."beszel-agent.env".path;

  smartmon = {
    enable = true;
    deviceAllow = [
      "/dev/sda"
      "/dev/sdb"
    ];
  };

  openFirewall = true;
};

systemd.services.beszel-agent.serviceConfig.StateDirectory = "beszel-agent";
}
