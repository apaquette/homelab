{ config, unstable, helpers, ... }:

[
  (helpers.assertEqual
    "ntfy-sh enabled"
    true
    config.services.ntfy-sh.enable)

  (helpers.assertEqual
    "ntfy-sh package"
    unstable.ntfy-sh
    config.services.ntfy-sh.package)

  (helpers.assertEqual
    "ntfy-sh base URL"
    "https://ntfy.alexpaquette.dev"
    config.services.ntfy-sh.settings.base-url)

  (helpers.assertEqual
    "ntfy-sh listen address"
    "127.0.0.1:8093"
    config.services.ntfy-sh.settings.listen-http)

  (helpers.assertEqual
    "ntfy-sh auth file"
    "/var/lib/ntfy-sh/auth.db"
    config.services.ntfy-sh.settings.auth-file)

  (helpers.assertEqual
    "ntfy-sh auth default access"
    "deny-all"
    config.services.ntfy-sh.settings.auth-default-access)

  (helpers.assertEqual
    "ntfy-sh cache file"
    "/var/lib/ntfy-sh/cache.db"
    config.services.ntfy-sh.settings.cache-file)

  (helpers.assertEqual
    "ntfy-sh behind proxy"
    true
    config.services.ntfy-sh.settings.behind-proxy)

  (helpers.assertContains
    "ntfy-sh wantedBy"
    "multi-user.target"
    config.systemd.services.ntfy-sh.wantedBy)

  (helpers.assertContains
    "ntfy-sh after"
    "network.target"
    config.systemd.services.ntfy-sh.after)
]
