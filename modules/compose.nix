{ config, pkgs, ... }:

{
  systemd.services.nextcloud-compose = {
    description = "Nextcloud Docker Compose stack";

    wantedBy = [ "multi-user.target" ];

    after = [
      "docker.service"
      "mnt-myraid.mount"
    ];

    requires = [
      "docker.service"
      "mnt-myraid.mount"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/opt/nextcloud";

      EnvironmentFile = config.sops.templates."nextcloud.env".path;

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };

  systemd.services.immich-compose = {
    description = "Immich Docker Compose stack";

    wantedBy = [ "multi-user.target" ];

    after = [
      "docker.service"
      "mnt-myraid.mount"
    ];

    requires = [
      "docker.service"
      "mnt-myraid.mount"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/opt/immich";

      EnvironmentFile = config.sops.templates."immich.env".path;

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };

  systemd.services.beszel-compose = {
    description = "Beszel Docker Compose stack";

    wantedBy = [ "multi-user.target" ];

    after = [
      "docker.service"
      "mnt-backup.mount"
      "mnt-myraid.mount"
    ];

    requires = [
      "docker.service"
      "mnt-backup.mount"
      "mnt-myraid.mount"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/opt/beszel";

      EnvironmentFile = config.sops.templates."beszel.env".path;

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };

  systemd.services.uptime-kuma-compose = {
    description = "Uptime Kuma Docker Compose stack";

    wantedBy = [ "multi-user.target" ];

    after = [
      "docker.service"
    ];

    requires = [
      "docker.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/opt/uptime-kuma";

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };

  systemd.services.jenkins-compose = {
    description = "Jenkins Docker Compose stack";

    wantedBy = [ "multi-user.target" ];

    after = [
      "docker.service"
    ];

    requires = [
      "docker.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/opt/jenkins";

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };

}
