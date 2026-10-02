{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    docker
    gawk
    gzip
    rsync
    unzip
  ];

  environment.etc = {
    "homelab/scripts/homelab-app-backup".source = ../scripts/homelab-app-backup;
    "homelab/scripts/homelab-backup-ntfy".source = ../scripts/homelab-backup-ntfy;
    "homelab/scripts/homelab-container-health".source = ../scripts/homelab-container-health;
    "homelab/scripts/homelab-disk-health".source = ../scripts/homelab-disk-health;
    "homelab/scripts/homelab-storage-health".source = ../scripts/homelab-storage-health;
    "homelab/scripts/homelab-storage-ntfy".source = ../scripts/homelab-storage-ntfy;
    "homelab/scripts/immich-backup".source = ../scripts/immich-backup;
    "homelab/scripts/nextcloud-backup.sh".source = ../scripts/nextcloud-backup.sh;
  };
}
