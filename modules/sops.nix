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

  sops.secrets."homepage-jellyfin-api-key" = {
    key = "homepage/jellyfin_api_key";
  };

  sops.secrets."homepage-sonarr-api-key" = {
    key = "homepage/sonarr_api_key";
  };

  sops.secrets."homepage-radarr-api-key" = {
    key = "homepage/radarr_api_key";
  };

  sops.secrets."homepage-qbittorrent-api-key" = {
    key = "homepage/qbittorrent_api_key";
  };

  sops.secrets."homepage-nextcloud-token" = {
    key = "homepage/nextcloud_token";
  };

  sops.secrets."homepage-immich-api-key" = {
    key = "homepage/immich_api_key";
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

  sops.templates."homepage.env" = {
    content = ''
      HOMEPAGE_VAR_JELLYFIN_API_KEY=${config.sops.placeholder."homepage-jellyfin-api-key"}
      HOMEPAGE_VAR_SONARR_API_KEY=${config.sops.placeholder."homepage-sonarr-api-key"}
      HOMEPAGE_VAR_RADARR_API_KEY=${config.sops.placeholder."homepage-radarr-api-key"}
      HOMEPAGE_VAR_QBITTORRENT_API_KEY=${config.sops.placeholder."homepage-qbittorrent-api-key"}
      HOMEPAGE_VAR_NEXTCLOUD_TOKEN=${config.sops.placeholder."homepage-nextcloud-token"}
      HOMEPAGE_VAR_IMMICH_API_KEY=${config.sops.placeholder."homepage-immich-api-key"}
    '';

    owner = "root";
    group = "root";
    mode = "0400";
  };
}
