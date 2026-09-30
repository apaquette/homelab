# Docker Compose

The homelab applications are deployed with Docker Compose.

NixOS manages the Docker runtime and Compose tooling. Application deployment
definitions remain in this repository as Compose files rather than being
translated into Nix expressions.

## Applications

| Application | Compose definition | Persistent state |
|---|---|---|
| Nextcloud | `compose/nextcloud/docker-compose.yml` | `/opt/nextcloud`, `/mnt/myraid/Nextcloud` |
| Immich | `compose/immich/docker-compose.yml` | `/opt/immich`, `/mnt/myraid/Immich` |
| Beszel | `compose/beszel/compose.yaml` | `/opt/beszel` |
| Uptime Kuma | `compose/uptime-kuma/compose.yaml` | `/opt/uptime-kuma` |
| ntfy | `compose/ntfy/compose.yaml` | `/opt/ntfy` |
| Jenkins | `compose/jenkins/compose.yaml` | `/opt/jenkins` |
| Homepage | `compose/homepage/compose.yaml` | `/opt/homepage` |

## Configuration and secrets

Secret values are not committed to the repository.

Nextcloud and Immich use environment variables for database credentials.
Example environment files are provided where useful; production secrets will
be managed separately with sops-nix.

## Custom images

Uptime Kuma and Homepage currently use local Dockerfiles to add the existing
Caddy local CA certificate to their Node.js trust configuration.

The Caddy CA is host-specific deployment state and is therefore not committed
to this repository. The migration will preserve the existing CA rather than
unnecessarily replacing it.

## Persistent application state

The Compose definitions describe how containers are deployed. Existing
application data and databases remain outside the Nix store and are preserved
during the OS migration.

The migration does not intentionally recreate or reset application state.