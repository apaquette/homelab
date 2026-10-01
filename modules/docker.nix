{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      dns = [
        "192.168.2.20"
      ];
    };
  };

  systemd.services.docker.serviceConfig.RequiresMountsFor = [
    "/mnt/myraid"
    "/mnt/backup"
  ];

  environment.systemPackages = [
    pkgs.docker-compose
  ];
}