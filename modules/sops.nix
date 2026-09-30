{ config, ... }:

{
  sops.defaultSopsFile = ../secrets/homelab.yaml;

  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.secrets."nextcloud-postgres-password" = {
    key = "nextcloud/postgres_password";
  };

  sops.secrets."immich-db-password" = {
    key = "immich/db_password";
  };

  sops.secrets."beszel-agent-token" = {
    key = "beszel/agent_token";
  };

  sops.secrets."smartd-ntfy-token" = {
    key = "smartd/ntfy_token";
  };

  environment.etc."smartd-ntfy-token".source =
    config.sops.secrets."smartd-ntfy-token".path;

  sops.templates."nextcloud.env" = {
    content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."nextcloud-postgres-password"}
    '';

    owner = "root";
    group = "root";
    mode = "0400";
  };

  sops.templates."immich.env" = {
    content = ''
      DB_PASSWORD=${config.sops.placeholder."immich-db-password"}
    '';

    owner = "root";
    group = "root";
    mode = "0400";
  };

  sops.templates."beszel.env" = {
    content = ''
      BESZEL_AGENT_TOKEN=${config.sops.placeholder."beszel-agent-token"}
    '';

    owner = "root";
    group = "root";
    mode = "0400";
  };
}