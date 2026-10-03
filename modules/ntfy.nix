{ config, unstable, ... }:

{
  services.ntfy-sh = {
    enable = true;
    package = unstable.ntfy-sh;

    settings = {
      base-url = "https://ntfy.alexpaquette.dev";
      listen-http = "127.0.0.1:8093";

      auth-file = "/var/lib/ntfy-sh/auth.db";
      auth-default-access = "deny-all";

      cache-file = "/var/lib/ntfy-sh/cache.db";

      behind-proxy = true;
    };
  };
}
