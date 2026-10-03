{ config, helpers, ... }:

with helpers;

[
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
    "SMART notification SOPS key"
    "smartd/ntfy_token"
    config.sops.secrets."smartd-ntfy-token".key)
]
