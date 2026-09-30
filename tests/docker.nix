{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "Docker enabled"
    true
    config.virtualisation.docker.enable)

  (assertContains
    "Docker DNS"
    "192.168.2.20"
    config.virtualisation.docker.daemon.settings.dns)
]