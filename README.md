# Homelab

Declarative NixOS configuration for my self-hosted homelab.

## Goals

- Declarative NixOS infrastructure
- Reproducible system configuration
- Docker and Docker Compose for containerized applications
- Declarative networking and storage
- Automated backups and monitoring
- Version-controlled infrastructure
- Secure secret management

## Host

| Host | Hardware | Role |
|------|----------|------|
| `homelab` | Intel Core i5-10600K / 32 GB RAM | Self-hosted services |

## Status

The configuration is currently in the **development and characterization** phase.

The production homelab currently runs Debian. This repository is being developed
and validated independently before the migration to NixOS.

### Current state

The NixOS configuration currently represents the major components of the
existing homelab, including:

- Networking and static addressing
- dnsmasq DHCP/DNS
- Existing RAID and backup storage
- User and group identities
- Docker and Docker Compose
- Caddy reverse proxy
- Jellyfin with Intel hardware acceleration
- Sonarr, Radarr, Prowlarr, and qBittorrent
- Seerr
- Minecraft
- SOPS-based secret management
- Monitoring and notification services
- Application backups
- SMART disk monitoring
- Compatibility support for prebuilt Linux applications

Configuration regression tests are organized by component under `tests/`.
The repository also uses GitHub Actions to run `nix flake check` and build the
NixOS system configuration.

### Migration boundary

The production Debian system has **not been replaced or modified as part of
this development work**.

The current workflow is:

1. Inspect the existing Debian configuration.
2. Represent the behavior declaratively in NixOS.
3. Characterize existing behavior with configuration tests.
4. Validate with `nix flake check`.
5. Build the complete NixOS system configuration.
6. Add NixOS VM tests where practical.
7. Perform hardware-specific validation.
8. Prepare and execute the production migration only after the configuration
   has been sufficiently validated.

Existing application data, databases, storage, and deployment state are treated
as migration assets rather than disposable state. The migration should preserve
them rather than intentionally recreating application environments.