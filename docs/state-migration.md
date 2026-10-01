# State Migration

This document defines how persistent application state is transferred from the existing Debian homelab installation to the NixOS installation during the production migration.

The initial migration deliberately preserves the existing application installations and Docker Compose deployments rather than replacing them with newly packaged NixOS services. The objective is to change the host operating system while minimizing application-level changes.

## Migration sources

The authoritative source for host-local state is the bootable clone of the existing Debian system disk created immediately before migration.

The `/mnt/backup` filesystem is an additional recovery source. It must not be used as the live source while it is mounted as the backup filesystem.

The RAID filesystem at `/mnt/myraid` is **not migrated or reformatted**. It remains in place and is mounted by UUID on the NixOS installation.

## Persistent state

The following host-local paths contain application state and must be preserved.

### Native services

| Path                   | Service     | Notes                                                              |
| ---------------------- | ----------- | ------------------------------------------------------------------ |
| `/var/lib/sonarr`      | Sonarr      | Database and application state                                     |
| `/var/lib/radarr`      | Radarr      | Database and application state                                     |
| `/var/lib/prowlarr`    | Prowlarr    | Database and application state                                     |
| `/var/lib/qBittorrent` | qBittorrent | Application state                                                  |
| `/var/lib/seerr`       | Seerr       | Application state                                                  |
| `/var/lib/jellyfin`    | Jellyfin    | Database, metadata and configuration                               |
| `/var/lib/minecraft`   | Minecraft   | World data, whitelist, server properties and other server state    |
| `/var/lib/caddy`       | Caddy       | ACME certificates, local CA state and other persistent Caddy state |

`/var/lib/minecraft/whitelist.json` is persistent application state. The initial migration does not make the whitelist declarative; restoring the Minecraft state directory preserves the existing whitelist.

### Docker Compose deployments

The following directories contain Compose deployment state and/or deployment configuration:

```text
/opt/nextcloud
/opt/immich
/opt/beszel
/opt/homepage
/opt/jenkins
/opt/ntfy
/opt/uptime-kuma
```

Their persistent components include:

```text
/opt/nextcloud/html
/opt/nextcloud/postgres
/opt/immich/postgres
/opt/beszel/data
/opt/beszel/agent-data
/opt/homepage/config
/opt/jenkins/data
/opt/ntfy/config
/opt/ntfy/data
/opt/uptime-kuma/data
```

The Nextcloud and Immich media libraries remain on `/mnt/myraid`:

```text
/mnt/myraid/Nextcloud
/mnt/myraid/Immich
```

These directories must not be copied onto the NixOS root filesystem.

### Native application installations

The initial migration preserves these existing application installations:

```text
/opt/Sonarr
/opt/Radarr
/opt/Prowlarr
/opt/seerr
/opt/minecraft
```

The `.old` application directories are not required:

```text
/opt/Sonarr.old
/opt/Radarr.old
/opt/Prowlarr.old
```

`/opt/containerd` is runtime state owned by the container runtime and is not manually migrated.

## Secrets

Secrets must not be copied into Git or embedded in the NixOS configuration.

The following secrets are managed by `sops-nix`:

* Nextcloud PostgreSQL password
* Immich database password
* Beszel agent token
* smartd ntfy token

The existing age private key is provisioned separately to:

```text
/var/lib/sops-nix/key.txt
```

The private key must never be committed to the repository or pasted into the migration documentation.

## Migration ordering

State restoration must occur only after the NixOS filesystems and required users/groups have been established.

The migration order is:

1. Boot the NixOS installer.
2. Verify the target system disk and all protected disks by stable device identifiers.
3. Install NixOS using the existing filesystem UUIDs.
4. Boot the new NixOS installation.
5. Verify `/mnt/myraid` and `/mnt/backup` are mounted correctly.
6. Verify the required users and groups exist with their expected UIDs/GIDs.
7. Restore native application state under `/var/lib`.
8. Restore the required `/opt` application and Compose directories.
9. Restore `/var/lib/caddy` before starting Caddy.
10. Provision `/var/lib/sops-nix/key.txt`.
11. Verify ownership and permissions.
12. Validate the NixOS configuration.
13. Start core services in dependency order.
14. Perform application smoke tests.

Services must not be allowed to initialize empty state directories when existing state is expected to be restored.

## Ownership and permissions

Existing ownership and permissions must be preserved during state restoration.

The characterized `/opt` directory ownership is:

```text
root:root           755  /opt/nextcloud
root:root           755  /opt/immich
apaquette:apaquette 755  /opt/beszel
apaquette:apaquette 755  /opt/homepage
apaquette:apaquette 755  /opt/jenkins
root:root           755  /opt/ntfy
apaquette:apaquette 755  /opt/uptime-kuma
sonarr:sonarr       755  /opt/Sonarr
radarr:radarr       755  /opt/Radarr
prowlarr:prowlarr   755  /opt/Prowlarr
apaquette:apaquette 755 /opt/seerr
root:minecraft      750  /opt/minecraft
```

The important `/var/lib` ownership is:

```text
apaquette:jellyfin       /var/lib/jellyfin
sonarr:sonarr             /var/lib/sonarr
radarr:radarr             /var/lib/radarr
prowlarr:prowlarr         /var/lib/prowlarr
qbittorrent:qbittorrent  /var/lib/qBittorrent
seerr:seerr               /var/lib/seerr
minecraft:minecraft       /var/lib/minecraft
caddy:caddy               /var/lib/caddy
```

The migration must preserve numeric ownership where possible. Ownership must be verified after restoration rather than assumed from directory names.

## Compose deployment files

The repository contains the canonical Compose definitions under:

```text
compose/
```

The NixOS systemd units currently expect the corresponding deployments at:

```text
/opt/nextcloud
/opt/immich
/opt/beszel
/opt/homepage
/opt/jenkins
/opt/ntfy
/opt/uptime-kuma
```

Therefore the migration must restore the required deployment files into those locations before enabling the corresponding systemd services.

The production Nextcloud Compose file previously observed on Debian was anomalously empty/missing. The repository's Nextcloud Compose definition is therefore the canonical deployment definition; the existing Nextcloud application state remains the authoritative source for its data.

## Caddy state

`/var/lib/caddy` must be restored before Caddy is started.

This directory contains persistent TLS/ACME and local CA state. Regenerating it during migration can invalidate certificates or require clients to trust a different local CA.

The migration must not intentionally delete or regenerate the existing Caddy state.

## Validation

Before starting application services, verify:

```text
/mnt/myraid
/mnt/backup
/var/lib/jellyfin
/var/lib/sonarr
/var/lib/radarr
/var/lib/prowlarr
/var/lib/qBittorrent
/var/lib/seerr
/var/lib/minecraft
/var/lib/caddy
/opt/nextcloud
/opt/immich
/opt/beszel
/opt/homepage
/opt/jenkins
/opt/ntfy
/opt/uptime-kuma
/opt/Sonarr
/opt/Radarr
/opt/Prowlarr
/opt/seerr
/opt/minecraft
```

The following must also be verified:

* `/mnt/myraid` contains the existing media and application data.
* Minecraft's existing world and whitelist are present.
* Caddy's existing persistent state is present.
* Nextcloud and Immich database state is present.
* Compose `.env` files containing secrets are supplied through the NixOS secret mechanism rather than committed to Git.
* Application users and groups have the expected numeric IDs.
* Docker does not start Compose applications before required storage mounts are available.
* No protected RAID or backup filesystem was reformatted or recreated.

## Rollback

If migration validation fails, shut down the NixOS installation and boot the preserved Debian system disk or its verified clone.

The RAID filesystem and backup filesystem must remain untouched during rollback.

NixOS generations provide configuration rollback after a successful NixOS boot, but the physical Debian clone remains the primary rollback mechanism for this operating-system migration.
