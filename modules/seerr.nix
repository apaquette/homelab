{ pkgs, ... }:

{
  services.seerr = {
    enable = true;
    package = pkgs.seerr;
    configDir = "/var/lib/seerr";
  };
}
