# Storage Layout

The homelab separates operating-system state from application state.

## Operating system

The NixOS root filesystem is located on the NVMe SSD:

- `/dev/nvme0n1p2`
- ext4
- UUID `4fb5e617-69a8-4358-8078-becef55d6598`

The EFI system partition is:

- `/dev/nvme0n1p1`
- vfat
- UUID `FD62-E6A2`

Swap:

- `/dev/nvme0n1p3`
- UUID `a1cc6a0f-053e-4b14-9558-3d39a6f34a93`

## RAID storage

`/mnt/myraid` is an existing RAID0 array:

- `/dev/md0`
- ext4
- filesystem UUID `f316b340-b988-4306-8164-9f7d11250a55`
- approximately 8 TB usable capacity

The RAID members are two 4 TB disks.

The array contains media and application data and must not be reformatted or recreated during the NixOS migration.

Important directories include:

- `/mnt/myraid/Videos`
- `/mnt/myraid/Audiobooks`
- `/mnt/myraid/Emulators`
- `/mnt/myraid/Nextcloud`
- `/mnt/myraid/Immich`

Existing ownership and permissions are part of the application configuration and must be preserved.

## Backup storage

`/mnt/backup` is a separate external disk:

- ext4
- filesystem UUID `2f26abd3-1603-4c8d-890c-a8a8aea9c5f1`

Backups are stored under:

```text
/mnt/backup/Backup/