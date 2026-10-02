{ pkgs, ... }:

{
  systemd.services.minecraft = {
    description = "Minecraft Java Edition Server";
    enable = true;

    after = [
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];
    preStart = ''
      ${pkgs.coreutils}/bin/printf '%s\n' 'eula=true' > /var/lib/minecraft/eula.txt

      if [ ! -f /var/lib/minecraft/server.properties ]; then
        ${pkgs.coreutils}/bin/printf '%s\n' \
          'server-port=4300' \
          > /var/lib/minecraft/server.properties
      elif ! ${pkgs.gnugrep}/bin/grep -q '^server-port=' /var/lib/minecraft/server.properties; then
        ${pkgs.coreutils}/bin/printf '%s\n' 'server-port=4300' >> /var/lib/minecraft/server.properties
      else
        ${pkgs.gnused}/bin/sed -i 's/^server-port=.*/server-port=4300/' /var/lib/minecraft/server.properties
      fi
    '';

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

    wantedBy = [
      "multi-user.target"
    ];
  };
}
