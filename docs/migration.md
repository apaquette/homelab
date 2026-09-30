# NixOS Migration

This repository is being developed to migrate the production homelab from Debian to NixOS 26.05.

The migration is intentionally incremental. The Debian production system remains the source of truth for existing runtime behavior until the NixOS configuration has been sufficiently characterized and validated.

## Migration phases

```text
Existing Debian system
        │
        │ Read-only inspection
        ▼
NixOS configuration
        │
        ├── Component characterization tests
        ├── nix flake check
        └── NixOS system build
        │
        ▼
NixOS VM tests
        │
        ▼
Hardware-specific validation
        │
        ▼
Production migration
```

## Current progress

### Repository and configuration

* [x] Nix Flake established
* [x] NixOS 26.05 target established
* [x] `homelab` host configuration established
* [x] Hardware configuration captured
* [x] User and group identities captured
* [x] Networking configuration represented
* [x] Storage and existing RAID configuration represented
* [x] Docker configuration represented
* [x] Caddy configuration represented
* [x] dnsmasq configuration represented
* [x] Jellyfin configuration represented
* [x] Sonarr/Radarr/Prowlarr/qBittorrent configuration represented
* [x] Seerr configuration represented
* [x] Minecraft configuration represented
* [x] Docker Compose deployment definitions preserved
* [x] SOPS structure established
* [x] Monitoring configuration represented
* [x] Backup configuration represented
* [x] SMART monitoring represented
* [x] Compatibility support for prebuilt applications represented

### Validation

* [x] Configuration regression test framework established
* [x] Tests split into component-specific files
* [x] Networking tests
* [x] Storage tests
* [x] User/group tests
* [x] Docker tests
* [x] Caddy tests
* [x] dnsmasq tests
* [x] Jellyfin tests
* [x] Media-services tests
* [x] Seerr tests
* [x] Minecraft tests
* [x] Monitoring tests
* [x] Backup tests
* [x] SMART monitoring tests
* [x] `nix flake check` validation
* [x] NixOS system build validation
* [x] GitHub Actions CI

### Remaining work

* [ ] Characterize Docker Compose services
* [ ] Characterize compatibility configuration
* [ ] Characterize script installation
* [ ] Characterize remaining hardware and boot configuration
* [ ] Add cross-component configuration invariants where useful
* [ ] Add NixOS VM tests
* [ ] Add hardware-specific validation
* [ ] Document the production deployment procedure
* [ ] Prepare production migration
* [ ] Execute production migration
* [ ] Perform post-migration smoke testing

## Testing methodology

Existing Debian behavior is first characterized rather than redesigned.

For an existing component:

1. Write tests describing the intended configuration contract.
2. Run the tests.
3. If they fail, determine whether the failure is caused by an incorrect test assumption or an implementation gap.
4. Correct the test when it does not accurately describe the existing behavior.
5. Modify the NixOS implementation only when the implementation genuinely does not satisfy the intended contract.
6. Run `nix flake check`.
7. Build the complete NixOS configuration.
8. Commit the completed milestone.

For genuinely new functionality, use the normal TDD cycle:

```text
Red → Implement → Green → Build → Commit
```

## Production safety boundary

Development and validation work is performed independently of the production Debian installation.

Unless a step is explicitly identified as a production deployment or migration operation:

* Do not modify the Debian system.
* Do not reformat or recreate existing storage.
* Do not intentionally reset application state.
* Do not regenerate host-specific deployment state unnecessarily.
* Prefer read-only inspection when collecting production configuration.

## Data preservation

Application state and user data exist outside the Nix store and are treated as persistent migration assets.

Important persistent locations include:

* `/mnt/myraid`
* `/mnt/backup`
* `/opt`
* `/var/lib/<service>`

The existing RAID0 array is particularly important: it must not be reformatted, recreated, or otherwise treated as disposable during the migration.

See [`storage-layout.md`](storage-layout.md) for the current storage layout and [`compose.md`](compose.md) for the containerized application state.
