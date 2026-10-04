# Homelab Architecture

## Overview

The homelab is implemented as a declarative NixOS system. Hardware, networking, services, persistent storage, secrets integration, monitoring, and backup policy are represented through Nix modules and systemd units.

The architecture separates three concerns:

1. **Declarative system state** — NixOS configuration stored in Git
2. **Mutable application state** — databases, application configuration, indexes, and user data
3. **Operational automation** — systemd timers, monitoring, notifications, and backups

This separation allows the operating environment to remain reproducible without treating application data as disposable configuration.

## System layers

```text
┌─────────────────────────────────────────────────────┐
│                    Git repository                   │
│                                                     │
│  flake.nix  modules/  hosts/  tests/  secrets/     │
└───────────────────────┬─────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│                       NixOS                         │
│                                                     │
│  system configuration                               │
│  users / groups                                     │
│  networking                                         │
│  storage mounts                                     │
│  packages                                            │
│  systemd units                                      │
└───────────────────────┬─────────────────────────────┘
                        │
          ┌─────────────┼──────────────┐
          ▼             ▼              ▼
      Services      PostgreSQL      Operations
                                    monitoring
                                    backups
                                    notifications
```

## Networking

The host provides the primary LAN infrastructure used by the homelab.

### dnsmasq

dnsmasq provides:

* DHCP
* LAN DNS
* local service records
* service discovery through the homelab domain

Internal service names resolve to the host on the local network, while Caddy handles the corresponding HTTP/TLS routing.

### Caddy

Caddy is the single reverse-proxy entry point for HTTP services.

Two access patterns are used:

* **public services** use externally reachable TLS endpoints
* **internal services** use Caddy's internal TLS authority and are restricted to the LAN

This keeps application services bound to local interfaces where possible rather than exposing individual application listeners directly.

## Application services

Applications are managed as native NixOS services.

Representative service groups include:

| Group            | Services                                     |
| ---------------- | -------------------------------------------- |
| Infrastructure   | Caddy, dnsmasq, PostgreSQL                   |
| File and media   | Nextcloud, Immich, Jellyfin                  |
| Media automation | Sonarr, Radarr, Prowlarr, qBittorrent, Seerr |
| Development      | Jenkins                                      |
| Monitoring       | Beszel, Uptime Kuma, ntfy, Cockpit, Homepage |
| Game hosting     | Minecraft                                    |

Each service is configured through its own NixOS module where practical.

This keeps service-specific concerns isolated while allowing the host configuration to express dependencies between services.

## Persistent storage

The host uses separate storage roles for operating-system state, primary application/media data, and backups.

```text
System NVMe
├── EFI system partition
├── NixOS root
└── swap

Primary storage
└── RAID-backed filesystem
    ├── application data
    ├── Nextcloud user data
    ├── Immich library
    └── media library

Backup storage
├── Restic repository
├── application recovery artifacts
└── other retained data
```

The large RAID-backed volume is treated as application/data storage rather than as an operating-system filesystem.

The dedicated backup disk is mounted independently from the primary data volume and hosts the production Restic repository.

## Databases

PostgreSQL provides database storage for stateful applications.

The database layer is kept separate from application binaries and is managed by NixOS.

Database-backed backups use explicit PostgreSQL dumps rather than relying only on filesystem copies. Where application consistency requires it, the backup job temporarily places the relevant service into a consistent state before creating the dump and filesystem snapshot.

## Secrets

Secrets are managed with sops-nix.

The flow is:

```text
Encrypted SOPS file
        │
        ▼
      NixOS
        │
        ├── runtime secret files
        ├── generated environment files
        └── generated service configuration
```

Secrets remain encrypted in Git and are materialized only on the host.

Examples include:

* database credentials
* application API tokens
* monitoring credentials
* notification credentials
* service-specific authentication material

## Service lifecycle

systemd is used as the operational control plane.

Service definitions declare:

* startup ordering
* service dependencies
* persistent state requirements
* restart behavior
* scheduled execution
* failure handlers

This is particularly important for backup jobs. Application backups are represented as independent oneshot services and timers rather than as a single imperative backup script.

## Monitoring

Monitoring is split between application availability, host metrics, and local health checks.

### Beszel

Beszel provides host monitoring and collects system-level metrics.

### Uptime Kuma

Uptime Kuma monitors service availability from the application perspective.

### Local health checks

Custom systemd jobs monitor:

* filesystem capacity
* inode usage
* RAID/storage health
* backup failures

Failure paths send notifications through ntfy.

## Backup architecture

Backups use Restic with a repository on dedicated backup storage.

The backup system is structured as:

```text
systemd timers
      │
      ▼
application backup service
      │
      ├── prepare application state
      ├── create database dump when required
      ├── capture persistent filesystem state
      └── write Restic snapshot
                │
                ▼
       Restic repository
                │
          retention / prune
                │
          integrity check
```

Application backup jobs run sequentially so that resource-intensive snapshots do not overlap unnecessarily and stateful services have predictable stop/start behavior.

See [`backup-and-restore.md`](backup-and-restore.md) for exact backup scopes, schedules, retention, and recovery procedures.

## Configuration validation

The repository uses Nix-based tests to assert important properties of the final system configuration.

Validation covers:

* module configuration
* service definitions
* dependency relationships
* networking
* storage
* secrets
* monitoring
* backup jobs
* NixOS VM behavior

The intended workflow is:

```text
edit configuration
      │
      ▼
nix flake check
      │
      ▼
nixos-rebuild build
      │
      ▼
activate configuration
      │
      ▼
verify runtime state
```

This makes configuration changes reviewable and repeatable instead of depending on undocumented manual setup.

## Design trade-offs

### Declarative configuration vs mutable application data

The Nix configuration defines how services are installed and operated, while application data remains outside the Nix store.

This allows application state to persist independently from configuration generations.

### Local backup repository

The Restic repository is on separate physical backup storage rather than the primary RAID volume.

This protects against failures affecting the primary application storage, but it is still a local backup. It is not a substitute for an off-site or geographically independent backup.

### Native service management

Managing services directly through NixOS increases declarative coverage and reduces dependency on ad-hoc orchestration.

It also means that service-specific state paths, permissions, and lifecycle behavior must be understood explicitly and encoded into the configuration.
