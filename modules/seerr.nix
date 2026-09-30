{ pkgs, ... }:

{
  systemd.services.seerr = {
    description = "Seerr";

    after = [
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      Type = "simple";

      User = "seerr";
      Group = "seerr";

      WorkingDirectory = "/opt/seerr";

      Environment = [
        "NODE_ENV=production"
        "CONFIG_DIRECTORY=/var/lib/seerr"
      ];

      ExecStart = "${pkgs.nodejs}/bin/node /opt/seerr/dist/index.js";

      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
    };

    wantedBy = [
      "multi-user.target"
    ];
  };
}