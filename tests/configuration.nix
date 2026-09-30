{ pkgs, lib, config }:

let
  assertEqual = name: expected: actual:
    assert lib.assertMsg (expected == actual)
      "${name}: expected ${builtins.toJSON expected}, got ${builtins.toJSON actual}";
    true;

  assertContains = name: value: list:
    assert lib.assertMsg (builtins.elem value list)
      "${name}: expected list to contain ${builtins.toJSON value}";
    true;

  assertPathExists = name: path:
    assert lib.assertMsg (builtins.pathExists path)
      "${name}: expected path to exist: ${toString path}";
    true;

  assertions = [
    # Repository structure
    (assertPathExists "flake.nix" ../flake.nix)
    (assertPathExists "homelab host" ../hosts/homelab/default.nix)
    (assertPathExists "hardware configuration" ../hosts/homelab/hardware-configuration.nix)
    (assertPathExists "users configuration" ../hosts/homelab/users.nix)

    # Networking
    (assertEqual
      "network manager enabled"
      true
      config.networking.networkmanager.enable)

    (assertEqual
      "static IP"
      "192.168.2.20"
      (builtins.head config.networking.interfaces.enp2s0.ipv4.addresses).address)

    (assertEqual
      "static IP prefix length"
      24
      (builtins.head config.networking.interfaces.enp2s0.ipv4.addresses).prefixLength)

    (assertEqual
      "default gateway"
      "192.168.2.1"
      config.networking.defaultGateway.address)

    (assertContains
      "DNS servers"
      "192.168.2.20"
      config.networking.nameservers)

    (assertContains
      "DNS servers"
      "1.1.1.1"
      config.networking.nameservers)

    (assertContains
      "DNS servers"
      "8.8.8.8"
      config.networking.nameservers)

    # Storage
    (assertEqual
      "fstrim enabled"
      true
      config.services.fstrim.enable)

    (assertEqual
      "RAID enablement"
      true
      config.boot.swraid.enable)

    (assertEqual
      "RAID array configuration"
      "ARRAY /dev/md/0 metadata=1.2 UUID=06feb5d7:8068ed2e:0d93f17f:649590b9\n"
      config.boot.swraid.mdadmConf)

    (assertEqual
      "myraid filesystem UUID"
      "/dev/disk/by-uuid/f316b340-b988-4306-8164-9f7d11250a55"
      config.fileSystems."/mnt/myraid".device)

    (assertEqual
      "backup filesystem UUID"
      "/dev/disk/by-uuid/2f26abd3-1603-4c8d-890c-a8a8aea9c5f1"
      config.fileSystems."/mnt/backup".device)

    (assertContains
      "myraid mount options"
      "nofail"
      config.fileSystems."/mnt/myraid".options)

    (assertContains
      "backup mount options"
      "nofail"
      config.fileSystems."/mnt/backup".options)

    # Users and groups
    (assertEqual
      "apaquette UID"
      1000
      config.users.users.apaquette.uid)

    (assertEqual
      "apaquette primary group"
      "apaquette"
      config.users.users.apaquette.group)

    (assertEqual
      "apaquette GID"
      1000
      config.users.groups.apaquette.gid)

    (assertEqual
      "www-data UID"
      33
      config.users.users."www-data".uid)

    (assertEqual
      "www-data GID"
      33
      config.users.groups."www-data".gid)

    (assertEqual
      "radarr UID"
      101
      config.users.users.radarr.uid)

    (assertEqual
      "radarr GID"
      103
      config.users.groups.radarr.gid)

    (assertEqual
      "sonarr UID"
      102
      config.users.users.sonarr.uid)

    (assertEqual
      "sonarr GID"
      104
      config.users.groups.sonarr.gid)

    (assertEqual
      "prowlarr UID"
      103
      config.users.users.prowlarr.uid)

    (assertEqual
      "prowlarr GID"
      105
      config.users.groups.prowlarr.gid)

    (assertEqual
      "qbittorrent UID"
      104
      config.users.users.qbittorrent.uid)

    (assertEqual
      "qbittorrent GID"
      106
      config.users.groups.qbittorrent.gid)

    (assertEqual
      "jellyfin UID"
      105
      config.users.users.jellyfin.uid)

    (assertEqual
      "jellyfin GID"
      107
      config.users.groups.jellyfin.gid)

    (assertEqual
      "seerr UID"
      106
      config.users.users.seerr.uid)

    (assertEqual
      "seerr GID"
      108
      config.users.groups.seerr.gid)

    (assertEqual
      "minecraft UID"
      997
      config.users.users.minecraft.uid)

    (assertEqual
      "minecraft GID"
      988
      config.users.groups.minecraft.gid)

    (assertEqual
      "jenkins-deploy UID"
      1001
      config.users.users.jenkins-deploy.uid)

    (assertEqual
      "jenkins-deploy GID"
      1001
      config.users.groups.jenkins-deploy.gid)

    # Docker
    (assertEqual
      "Docker enabled"
      true
      config.virtualisation.docker.enable)

    (assertContains
      "Docker DNS"
      "192.168.2.20"
      config.virtualisation.docker.daemon.settings.dns)

    # Jellyfin graphics
    (assertEqual
      "Jellyfin enabled"
      true
      config.services.jellyfin.enable)

    (assertContains
      "Jellyfin graphics packages"
      pkgs.intel-media-driver
      config.hardware.graphics.extraPackages)

    (assertContains
      "Jellyfin graphics packages"
      pkgs.intel-compute-runtime
      config.hardware.graphics.extraPackages)

    (assertContains
      "Jellyfin graphics packages"
      pkgs.vpl-gpu-rt
      config.hardware.graphics.extraPackages)

    (assertEqual
      "Jellyfin VA-API driver"
      "iHD"
      config.systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME)

    # Scripts
    (assertPathExists
      "homelab-app-backup script"
      ../scripts/homelab-app-backup)

    (assertPathExists
      "homelab-backup-ntfy script"
      ../scripts/homelab-backup-ntfy)

    (assertPathExists
      "homelab-container-health script"
      ../scripts/homelab-container-health)

    (assertPathExists
      "homelab-disk-health script"
      ../scripts/homelab-disk-health)

    (assertPathExists
      "homelab-storage-health script"
      ../scripts/homelab-storage-health)

    (assertPathExists
      "homelab-storage-ntfy script"
      ../scripts/homelab-storage-ntfy)

    (assertPathExists
      "immich-backup script"
      ../scripts/immich-backup)

    (assertPathExists
      "nextcloud-backup script"
      ../scripts/nextcloud-backup.sh)

    (assertPathExists
      "smartd-ntfy script"
      ../scripts/smartd-ntfy)

    # Monitoring
    (assertEqual
      "container health timer interval"
      "15min"
      config.systemd.timers.homelab-container-health.timerConfig.OnUnitActiveSec)

    (assertEqual
      "disk health timer interval"
      "15min"
      config.systemd.timers.homelab-disk-health.timerConfig.OnUnitActiveSec)

    (assertEqual
      "storage health timer interval"
      "15min"
      config.systemd.timers.homelab-storage-health.timerConfig.OnUnitActiveSec)

    (assertEqual
      "storage health failure notification"
      [ "homelab-storage-notify@%p.service" ]
      config.systemd.services.homelab-storage-health.onFailure)

    (assertEqual
      "backup failure notification"
      [ "homelab-backup-notify@%p.service" ]
      config.systemd.services.homelab-app-backup.onFailure)

    # Backup schedules
    (assertEqual
      "application backup schedule"
      "*-*-* 04:00:00"
      config.systemd.timers.homelab-app-backup.timerConfig.OnCalendar)

    (assertEqual
      "Nextcloud backup schedule"
      "*-*-* 02:30:00"
      config.systemd.timers.nextcloud-backup.timerConfig.OnCalendar)

    (assertEqual
      "Immich backup schedule"
      "*-*-* 03:00:00"
      config.systemd.timers.immich-backup.timerConfig.OnCalendar)

    # SMART monitoring
    (assertEqual
      "smartd enabled"
      true
      config.services.smartd.enable)

    (assertEqual
      "smartd autodetection"
      false
      config.services.smartd.autodetect)

    (assertEqual
      "smartd device count"
      3
      (builtins.length config.services.smartd.devices))

    (assertEqual
      "smartd notification command"
      [ "-M" "exec /etc/homelab/scripts/smartd-ntfy" ]
      config.services.smartd.extraOptions)

    # SOPS
    (assertEqual
      "SOPS default file"
      ../secrets/homelab.yaml
      config.sops.defaultSopsFile)

    (assertEqual
      "SOPS age key file"
      "/var/lib/sops-nix/key.txt"
      config.sops.age.keyFile)

    (assertEqual
      "Nextcloud SOPS key"
      "nextcloud/postgres_password"
      config.sops.secrets."nextcloud-postgres-password".key)

    (assertEqual
      "Immich SOPS key"
      "immich/db_password"
      config.sops.secrets."immich-db-password".key)

    (assertEqual
      "Beszel SOPS key"
      "beszel/agent_token"
      config.sops.secrets."beszel-agent-token".key)

    (assertEqual
      "SMART notification SOPS key"
      "smartd/ntfy_token"
      config.sops.secrets."smartd-ntfy-token".key)

    # Compatibility
    (assertEqual
      "nix-ld enabled"
      true
      config.programs.nix-ld.enable)

    # State version
    (assertEqual
      "NixOS state version"
      "26.05"
      config.system.stateVersion)
  ];
in
pkgs.runCommand "homelab-configuration-tests" {} ''
  echo "All ${toString (builtins.length assertions)} configuration assertions passed."
  touch $out
''