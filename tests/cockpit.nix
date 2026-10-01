{ config, helpers }:

[
  (helpers.assertEqual
    "cockpit enabled"
    true
    config.services.cockpit.enable)

  (helpers.assertEqual
    "cockpit port"
    9090
    config.services.cockpit.port)
]