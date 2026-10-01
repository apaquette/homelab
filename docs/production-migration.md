# Production Migration

This document describes the planned migration of the production homelab from Debian to NixOS.

The migration is a controlled replacement of the operating system. Existing application data, media, RAID storage, and host-specific state are treated as migration assets and must be preserved.

## Preconditions

Before beginning the production migration:

* The NixOS configuration passes `nix flake check`.
* The complete NixOS configuration builds successfully.
* NixOS VM tests pass.
* Hardware-specific configuration tests pass.
* The repository is committed and the Git working tree is clean.
* A current backup of important application data is available.
* The existing Debian system has been inspected and its important runtime state has been characterized.
* The NixOS configuration has been reviewed against the current production configuration.

The migration should not begin if any of these conditions are unresolved.

## Production storage

The existing storage must be preserved.

### Operating-system disk

The NixOS installation target is the existing NVMe system disk:

* `/dev/nvme0n1p1` — EFI system partition
* `/dev/nvme0n1p2` — NixOS root filesystem
* `/dev/nvme0n1p3` — swap

The root filesystem may be reformatted as part of the OS installation because it contains the operating system being replaced.

The EFI partition must be handled carefully because it contains bootloader state.

### Existing RAID

The existing `/dev/md0` RAID0 array is persistent application/media storage.

It must **not** be:

* reformatted;
* recreated;
* reassembled with different members;
* renamed;
* converted;
* repartitioned.

Its existing filesystem UUID is:

```text
f316b340-b988-4306-8164-9f7d11250a55
```

The existing mdadm array UUID is:

```text
06feb5d7:8068ed2e:0d93f17f:649590b9
```

The NixOS configuration references these existing identities.

### Backup disk

The backup filesystem is mounted at:

```text
/mnt/backup
```

with filesystem UUID:

```text
2f26abd3-1603-4c8d-890c-a8a8aea9c5f1
```

It must not be reformatted during migration.

## Pre-migration preparation

While Debian is still running:

1. Confirm all important services are operational.
2. Confirm recent application backups completed successfully.
3. Confirm the RAID array is healthy.
4. Confirm the backup disk is accessible.
5. Record any temporary application state that must be restored manually.
6. Ensure the NixOS repository is available independently of the production system.
7. Verify the NixOS installer media.
8. Verify network access from the migration environment.

No production configuration changes are required merely to prepare the NixOS installation.

## Installation

Boot the server using the NixOS installer.

Before modifying disks:

1. Identify the NVMe system disk.
2. Identify both RAID member disks.
3. Identify the backup disk.
4. Verify the devices using stable identifiers such as `/dev/disk/by-id`.
5. Confirm that the intended installation target is the NVMe system disk.

Do not proceed if disk identification is ambiguous.

The NixOS root filesystem and required EFI installation state are created on the system disk.

The existing RAID members and backup disk are left untouched.

## Configuration deployment

After installing the base NixOS system:

1. Make the `homelab` repository available on the new system.
2. Verify the repository revision being deployed.
3. Verify the expected hardware configuration.
4. Verify the existing filesystem UUIDs.
5. Verify the existing RAID metadata.
6. Configure the age key required by sops-nix.
7. Deploy the `homelab` NixOS configuration.
8. Reboot into the resulting system.

Secrets must not be copied into the Git repository or embedded directly into the Nix configuration.

## First boot validation

After booting NixOS, validate the system in stages.

### Hardware

Verify:

* system booted using UEFI/systemd-boot;
* NVMe root filesystem is mounted;
* expected swap is active;
* Intel graphics device is present;
* `/dev/dri` is available;
* RAID array is assembled;
* `/mnt/myraid` is mounted;
* `/mnt/backup` is mounted.

### Networking

Verify:

* the server has `192.168.2.20`;
* dnsmasq is operational;
* DNS resolution works;
* DHCP is operational;
* Caddy is operational;
* local service names resolve correctly.

### Core infrastructure

Verify:

* Docker is running;
* Compose services can start;
* SOPS secrets decrypt successfully;
* Caddy can reach its configured upstreams.

### Native services

Verify:

* Jellyfin;
* Sonarr;
* Radarr;
* Prowlarr;
* qBittorrent;
* Seerr;
* Minecraft.

### Monitoring and backups

Verify:

* SMART monitoring;
* storage health checks;
* disk health checks;
* container health checks;
* application backups;
* Nextcloud backup;
* Immich backup;
* ntfy notifications.

## Application smoke testing

Perform representative end-to-end checks rather than merely checking systemd unit state.

Examples:

* Open Jellyfin and play media.
* Confirm hardware transcoding works.
* Open Sonarr/Radarr/Prowlarr.
* Confirm qBittorrent can access the existing download data.
* Open Seerr.
* Verify Nextcloud can access existing data.
* Verify Immich can access its existing library.
* Verify Minecraft starts with the existing world data.
* Verify the internal Caddy services are reachable.
* Verify notifications can be delivered.

Existing application data must remain intact throughout these checks.

## Rollback

If the NixOS deployment cannot provide reliable service, the primary rollback path is to boot the previous Debian installation or restore the previous system disk state.

Rollback must not require modifying or recreating the existing RAID data.

Before declaring the migration successful, retain a known-good rollback path.

## Migration completion

The migration is considered complete only after:

* hardware validation passes;
* storage validation passes;
* networking validation passes;
* core infrastructure is operational;
* application smoke tests pass;
* backups are operational;
* monitoring is operational;
* no unexpected data loss or permission changes are observed.

The final deployed Git revision should be recorded so the running system can be traced back to an exact repository state.
