{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
  };

  systemd.services.jellyfin = {
    after = [ "mnt-myraid.mount" ];
    requires = [ "mnt-myraid.mount" ];
    environment = {
        LIBVA_DRIVER_NAME = "iHD";
    };
  };
  systemd.tmpfiles.rules = [
    "Z /var/lib/jellyfin/plugins 0755 jellyfin jellyfin -"
    "Z /var/lib/jellyfin/metadata 0755 jellyfin jellyfin -"
    "Z /var/lib/jellyfin/root 0755 jellyfin jellyfin -"
    "Z /var/cache/jellyfin/images 0755 jellyfin jellyfin -"
    "Z /var/cache/jellyfin/omdb 0755 jellyfin jellyfin -"
    "Z /var/cache/jellyfin/transcodes 0755 jellyfin jellyfin -"
  ];
}
