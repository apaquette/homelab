{ config, pkgs, ... }:

{
  sops.templates."homepage.env" = { };

  services.homepage-dashboard = {
    enable = true;
    package = pkgs.homepage-dashboard;

    listenPort = 3000;
    allowedHosts = "homepage.alexpaquette.dev";
    openFirewall = false;

    environmentFiles = [
      config.sops.templates."homepage.env".path
    ];

    settings = {
      title = "Homelab";
      description = "Alex's Homelab";
      theme = "dark";
      color = "slate";

      layout = {
        Media = {
          style = "row";
          columns = 4;
        };

        Cloud = {
          style = "row";
          columns = 3;
        };

        Infrastructure = {
          style = "row";
          columns = 3;
        };

        Development = {
          style = "row";
          columns = 1;
        };
      };

      providers = {
        openweathermap = "openweathermapapikey";
        weatherapi = "weatherapiapikey";
      };
    };

    bookmarks = [
      {
        Developer = [
          {
            Github = {
              abbr = "GH";
              href = "https://github.com/";
            };
          }
        ];
      }
      {
        Social = [
          {
            Reddit = {
              abbr = "RE";
              href = "https://reddit.com/";
            };
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = {
              abbr = "YT";
              href = "https://youtube.com/";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];

    services = [
      {
        Media = [
          {
            Jellyfin = {
              icon = "jellyfin.png";
              href = "https://jellyfin.alexpaquette.dev";
              description = "Media server";
              widget = {
                type = "jellyfin";
                url = "http://127.0.0.1:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                enableNowPlaying = true;
              };
            };
          }

          {
            Seerr = {
              icon = "seerr.png";
              href = "https://seerr.alexpaquette.dev";
              description = "Media requests";
            };
          }

          {
            Sonarr = {
              icon = "sonarr.png";
              href = "https://sonarr.alexpaquette.dev";
              description = "TV management";
              widget = {
                type = "sonarr";
                url = "http://127.0.0.1:8989";
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
              };
            };
          }

          {
            Radarr = {
              icon = "radarr.png";
              href = "https://radarr.alexpaquette.dev";
              description = "Movie management";
              widget = {
                type = "radarr";
                url = "http://127.0.0.1:7878";
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
              };
            };
          }

          {
            Prowlarr = {
              icon = "prowlarr.png";
              href = "https://prowlarr.alexpaquette.dev";
              description = "Indexer management";
            };
          }

          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "https://qbittorrent.alexpaquette.dev";
              description = "Download client";
              widget = {
                type = "qbittorrent";
                url = "http://127.0.0.1:8080";
                key = "{{HOMEPAGE_VAR_QBITTORRENT_API_KEY}}";
                enableLeechProgress = true;
                enableLeechSize = true;
              };
            };
          }
        ];
      }

      {
        Cloud = [
          {
            Nextcloud = {
              icon = "nextcloud.png";
              href = "https://cloud.alexpaquette.dev";
              description = "Personal cloud";
              widget = {
                type = "nextcloud";
                url = "http://127.0.0.1:8081";
                key = "{{HOMEPAGE_VAR_NEXTCLOUD_TOKEN}}";
                fields = [
                  "freespace"
                  "activeusers"
                  "numfiles"
                  "numshares"
                ];
              };
            };
          }

          {
            Immich = {
              icon = "immich.png";
              href = "https://immich.alexpaquette.dev";
              description = "Photo and video library";
              widget = {
                type = "immich";
                url = "http://127.0.0.1:2283";
                key = "{{HOMEPAGE_VAR_IMMICH_API_KEY}}";
                version = 2;
              };
            };
          }

          {
            ntfy = {
              icon = "ntfy.png";
              href = "https://ntfy.alexpaquette.dev";
              description = "Notifications";
            };
          }
        ];
      }

      {
        Infrastructure = [
          {
            "Uptime Kuma" = {
              icon = "uptime-kuma.png";
              href = "https://status.alexpaquette.dev";
              description = "Service monitoring";
              widget = {
                type = "uptimekuma";
                url = "http://127.0.0.1:3001";
                slug = "homelab";
              };
            };
          }

          {
            Beszel = {
              icon = "beszel.png";
              href = "https://beszel.alexpaquette.dev";
              description = "System monitoring";
            };
          }

          {
            Cockpit = {
              icon = "cockpit.png";
              href = "https://cockpit.alexpaquette.dev";
              description = "Server administration";
            };
          }
        ];
      }

      {
        Development = [
          {
            Jenkins = {
              icon = "jenkins.png";
              href = "https://jenkins.alexpaquette.dev";
              description = "CI/CD";
            };
          }
        ];
      }
    ];
  };
}
