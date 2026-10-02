{ ... }:

{
  systemd.services.homelab-app-backup = {
    description = "Backup Sonarr, Radarr, Jellyfin, Jenkins and Homepage application data";

    after = [
      "local-fs.target"
      "mnt-backup.mount"
    ];

    requires = [
      "mnt-backup.mount"
    ];

    onFailure = [
      "homelab-backup-notify@%p.service"
    ];

    serviceConfig = {
      Type = "oneshot";

      ExecStart = "/etc/homelab/scripts/homelab-app-backup";
    };
  };

  systemd.timers.homelab-app-backup = {
    description = "Daily application backup";

    wantedBy = [
      "timers.target"
    ];

    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
  };

  systemd.services.nextcloud-backup = {
    description = "Nextcloud Backup";

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

      ExecStart = "/etc/homelab/scripts/nextcloud-backup.sh";
    };
  };

  systemd.timers.nextcloud-backup = {
    description = "Daily Nextcloud Backup";

    wantedBy = [
      "timers.target"
    ];

    timerConfig = {
      OnCalendar = "*-*-* 02:30:00";
      Persistent = true;
    };
  };

  systemd.services.immich-backup = {
    description = "Immich backup";

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

      ExecStart = "/etc/homelab/scripts/immich-backup";
    };
  };

  systemd.timers.immich-backup = {
    description = "Daily Immich backup";

    wantedBy = [
      "timers.target"
    ];

    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
  };
}
