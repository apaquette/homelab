{ config, unstable, ... }:

{
  services.immich = {
    enable = true;

    package = unstable.immich;

    host = "127.0.0.1";
    port = 2283;

    mediaLocation = "/mnt/myraid/Immich/library";

    machine-learning.enable = true;
    accelerationDevices = [ ];

    database = {
      enable = true;
      createDB = true;
      name = "immich";
      user = "immich";
      host = "/run/postgresql";
    };

    redis = {
      enable = true;
      port = 0;
    };

    settings = null;
  };

  systemd.services.immich-server = {
    after = [ "mnt-myraid.mount" ];
    requires = [ "mnt-myraid.mount" ];
  };
}
