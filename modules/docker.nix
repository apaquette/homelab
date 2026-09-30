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

  environment.systemPackages = [
    pkgs.docker-compose
  ];
}