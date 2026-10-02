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

  systemd.services.jellyfin.environment = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
