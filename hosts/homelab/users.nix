{ ... }:

{
  users.users.apaquette = {
    isNormalUser = true;
    uid = 1000;
    group = "apaquette";

    extraGroups = [
      "wheel"
      "video"
      "users"
    ];
  };

  users.groups.apaquette.gid = 1000;
  users.groups.users.gid = 100;

  users.users.www-data = {
    isSystemUser = true;
    uid = 33;
    group = "www-data";
  };

  users.groups.www-data.gid = 33;

  users.users.radarr = {
    isSystemUser = true;
    uid = 101;
    group = "radarr";
    extraGroups = [ "apaquette" ];
  };

  users.groups.radarr.gid = 103;

  users.users.sonarr = {
    isSystemUser = true;
    uid = 102;
    group = "sonarr";
    extraGroups = [ "apaquette" ];
  };

  users.groups.sonarr.gid = 104;

  users.users.prowlarr = {
    isSystemUser = true;
    uid = 103;
    group = "prowlarr";
  };

  users.groups.prowlarr.gid = 105;

  users.users.qbittorrent = {
    isSystemUser = true;
    uid = 104;
    group = "qbittorrent";
    home = "/var/lib/qBittorrent";
    createHome = false;
    extraGroups = [ "apaquette" ];
  };

  users.groups.qbittorrent.gid = 106;

  users.users.jellyfin = {
    isSystemUser = true;
    uid = 105;
    group = "jellyfin";
    extraGroups = [
      "video"
      "render"
    ];
  };

  users.groups.jellyfin.gid = 107;

  users.users.seerr = {
    isSystemUser = true;
    uid = 106;
    group = "seerr";
  };

  users.groups.seerr.gid = 108;

  users.users.minecraft = {
    isSystemUser = true;
    uid = 997;
    group = "minecraft";
  };

  users.groups.minecraft.gid = 988;

  users.users.jenkins-deploy = {
    isSystemUser = true;
    uid = 1001;
    group = "jenkins-deploy";
  };

  users.groups.jenkins-deploy.gid = 1001;
}