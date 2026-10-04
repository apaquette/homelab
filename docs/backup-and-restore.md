# Backup and Restore

## Overview

Application backups are implemented declaratively with NixOS systemd units and Restic.

The design goal is to produce recoverable snapshots of application state while preserving database consistency and keeping backup behavior reproducible.

The production repository is:

```text
/mnt/backup/Restic/homelab
```

The repository password is managed through sops-nix rather than stored in the Nix configuration or repository in plaintext.

## Backup model

Each application has its own Restic backup job.

```text
systemd timer
    │
    ▼
backup service
    │
    ├── prepare state
    ├── stop application when required
    ├── create database dump when required
    ├── snapshot persistent data
    └── restore application state
```

Application backups run sequentially.

This gives the backup system deterministic ordering and avoids having several large snapshots compete for disk and CPU resources simultaneously.

## Application backup scopes

| Application | Backup scope                    | Database handling             |
| ----------- | ------------------------------- | ----------------------------- |
| Nextcloud   | Application state and user data | PostgreSQL custom-format dump |
| Immich      | Full persistent Immich storage  | PostgreSQL custom-format dump |
| Minecraft   | Server data directory           | Filesystem snapshot           |
| Jellyfin    | Application state               | Filesystem snapshot           |
| Sonarr      | Application data directory      | Filesystem snapshot           |
| Radarr      | Application data directory      | Filesystem snapshot           |
| Beszel      | Persistent hub state            | Filesystem snapshot           |
| ntfy        | Persistent state directory      | Filesystem snapshot           |

The Jellyfin media library is intentionally excluded from the application backup scope. Media stored on the primary media volume is treated differently from mutable application state.

Homepage and other fully declarative services are not backed up as application state when their configuration is reproducible directly from Git.

## Special cases

### Nextcloud

Nextcloud backups include:

```text
/var/lib/nextcloud
/mnt/myraid/Nextcloud
PostgreSQL dump
```

The database dump is created in the same temporary runtime area as the backup operation and is included in the same Restic snapshot as the application state.

The backup process:

1. checks whether Nextcloud is already in maintenance mode
2. enables maintenance mode only when necessary
3. stops the Nextcloud cron timer/service as required
4. creates a PostgreSQL custom-format dump
5. validates the dump with `pg_restore --list`
6. creates the Restic snapshot
7. removes the temporary dump
8. restores the application to its previous operational state

If maintenance mode was already enabled before the backup started, the backup does not disable it during cleanup.

### Immich

Immich backups include the parent storage root:

```text
/mnt/myraid/Immich
```

This captures the complete persistent Immich storage layout rather than only the library subdirectory.

A PostgreSQL custom-format dump is created before the Restic snapshot.

The dump is validated with:

```bash
pg_restore --list
```

### DynamicUser services

Some NixOS services use systemd `DynamicUser` and `StateDirectory`.

For these services, the public `/var/lib/...` path may be a symlink to a private state directory.

The backup configuration therefore targets the actual persistent state paths:

```text
Beszel:
  /var/lib/private/beszel-hub

ntfy:
  /var/lib/private/ntfy-sh
```

This is important because backing up only the public symlink can result in a successful Restic command that contains no application data.

## Schedule

Backups are scheduled as follows:

| Time         | Job                               |
| ------------ | --------------------------------- |
| 02:30        | Nextcloud                         |
| 03:00        | Immich                            |
| 03:30        | Minecraft                         |
| 04:00        | Jellyfin                          |
| 04:15        | Sonarr                            |
| 04:30        | Radarr                            |
| 04:45        | Beszel                            |
| 05:00        | ntfy                              |
| 05:30        | Restic maintenance                |
| Sunday 06:00 | Restic repository integrity check |

Timers are persistent so missed executions can be handled when the host becomes available again.

## Retention

Snapshots are grouped by:

```text
host,tags
```

Retention policy:

```text
14 daily
8 weekly
6 monthly
```

Maintenance performs snapshot pruning and repository cleanup.

The configuration deliberately keeps retention policy in Nix so it is version-controlled alongside the backup architecture.

## Failure handling

Backup services use systemd failure dependencies to trigger ntfy notifications when a backup fails.

This provides two layers of protection:

```text
backup failure
     │
     ├── systemd records failure
     │
     └── notification service
              │
              ▼
             ntfy
```

Health checks also monitor storage capacity and inode usage.

## Repository verification

Repository integrity is checked independently from normal backup execution.

The integrity job runs:

```bash
restic check
```

and validates:

* repository indexes
* packs
* snapshots
* trees
* blobs

The intended operating pattern is:

```text
backup
  ↓
maintenance / prune
  ↓
integrity check
```

A repository check is also performed after significant cleanup operations.

## Restore validation

Backups are not considered validated merely because `restic backup` exits successfully.

Validation is performed against actual snapshots.

### Database validation

Database dumps are extracted directly from Restic snapshots and inspected with:

```bash
pg_restore --list backup.dump
```

This verifies that the snapshot contains a structurally valid PostgreSQL dump.

### Filesystem validation

Representative files are restored directly from Restic snapshots and compared against known-good source data using SHA-256 hashes.

Example:

```bash
sha256sum restored-file
sha256sum source-file
```

This verifies that the bytes retrieved from the repository match the expected source data.

### Repository validation

The Restic repository is also checked with:

```bash
restic check
```

A successful check reports that no repository errors were found.

## Recovery workflow

A normal application recovery consists of:

```text
1. Identify the required snapshot
2. Inspect snapshot contents
3. Restore application files to a temporary location
4. Restore or validate the database dump
5. Stop the affected application
6. Restore the required production paths
7. Start the application
8. Verify service health
9. Verify application-level functionality
```

Recovery should be performed selectively whenever possible rather than blindly overwriting the entire host.

## Example inspection commands

List snapshots:

```bash
sudo nix shell nixpkgs#restic -c restic \
  --repo /mnt/backup/Restic/homelab \
  --password-file /run/secrets/restic-repository-password \
  snapshots --compact
```

Inspect a snapshot:

```bash
sudo nix shell nixpkgs#restic -c restic \
  --repo /mnt/backup/Restic/homelab \
  --password-file /run/secrets/restic-repository-password \
  ls <snapshot-id>
```

Extract a file:

```bash
sudo nix shell nixpkgs#restic -c restic \
  --repo /mnt/backup/Restic/homelab \
  --password-file /run/secrets/restic-repository-password \
  dump <snapshot-id> <path> > restored-file
```

Check the repository:

```bash
sudo nix shell nixpkgs#restic -c restic \
  --repo /mnt/backup/Restic/homelab \
  --password-file /run/secrets/restic-repository-password \
  check
```

## Recovery limitations

The Restic repository is stored on a separate local physical disk, which provides useful isolation from the primary application volume.

It does **not** provide protection against:

* loss of the entire host
* theft or physical destruction affecting both disks
* site-level disasters
* compromise of the host and backup storage simultaneously

An off-site or independently hosted backup would be the next step for stronger disaster recovery.
