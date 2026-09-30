{ pkgs, ... }:

{
  systemd.services.minecraft = {
    description = "Minecraft Java Edition Server";

    after = [
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      User = "minecraft";
      Group = "minecraft";

      WorkingDirectory = "/var/lib/minecraft";

      ExecStart = "${pkgs.jdk21}/bin/java -Xms2048M -Xmx4096M -jar /opt/minecraft/server.jar nogui";

      Restart = "on-failure";
      RestartSec = 10;

      TimeoutStopSec = 30;
      KillSignal = "SIGINT";
    };

    wantedBy = [ "multi-user.target" ];
  };
}