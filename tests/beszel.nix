{ config, unstable, helpers,lib, ... }:

with helpers;

[
  # Hub

  (assertEqual
    "beszel hub enabled"
    true
    config.services.beszel.hub.enable)

  (assertEqual
    "beszel hub package"
    unstable.beszel
    config.services.beszel.hub.package)

  (assertEqual
    "beszel hub version"
    "0.20.0"
    config.services.beszel.hub.package.version)

  (assertEqual
    "beszel hub host"
    "127.0.0.1"
    config.services.beszel.hub.host)

  (assertEqual
    "beszel hub port"
    8090
    config.services.beszel.hub.port)

  (assertEqual
    "beszel hub data directory"
    "/var/lib/beszel-hub"
    config.services.beszel.hub.dataDir)

  (assertEqual
    "beszel hub APP_URL"
    "https://beszel.alexpaquette.dev"
    config.services.beszel.hub.environment.APP_URL)

  (assertEqual
    "beszel hub StateDirectory"
    "beszel-hub"
    config.systemd.services.beszel-hub.serviceConfig.StateDirectory)

  (assertEqual
    "beszel hub DynamicUser"
    true
    config.systemd.services.beszel-hub.serviceConfig.DynamicUser)

(assertEqual
  "beszel hub ExecStart"
  "${unstable.beszel}/bin/beszel-hub serve --http='127.0.0.1:8090'"
  (lib.strings.trim config.systemd.services.beszel-hub.serviceConfig.ExecStart))

(assertEqual
  "beszel hub ExecStartPre"
  [ "${unstable.beszel}/bin/beszel-hub migrate up" ]
  config.systemd.services.beszel-hub.serviceConfig.ExecStartPre)

  (assertEqual
    "beszel hub Restart"
    "on-failure"
    config.systemd.services.beszel-hub.serviceConfig.Restart)

  (assertContains
    "beszel hub wantedBy"
    "multi-user.target"
    config.systemd.services.beszel-hub.wantedBy)

  (assertContains
    "beszel hub after"
    "network-online.target"
    config.systemd.services.beszel-hub.after)


  # Agent

  (assertEqual
    "beszel agent enabled"
    true
    config.services.beszel.agent.enable)

  (assertEqual
    "beszel agent package"
    unstable.beszel
    config.services.beszel.agent.package)

  (assertEqual
    "beszel agent version"
    "0.20.0"
    config.services.beszel.agent.package.version)

  (assertEqual
    "beszel agent LISTEN"
    "45876"
    config.services.beszel.agent.environment.LISTEN)

  (assertEqual
    "beszel agent KEY"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDTGvwZ3qofUZxq9cVmeVz0n9dfA9IRHwxyYvyLyboP"
    config.services.beszel.agent.environment.KEY)

  (assertEqual
    "beszel agent HUB_URL"
    "http://127.0.0.1:8090"
    config.services.beszel.agent.environment.HUB_URL)

  (assertEqual
    "beszel agent EXTRA_FILESYSTEMS"
    "/mnt/backup__Backup_Storage,/mnt/myraid__RAID_Storage__"
    config.services.beszel.agent.environment.EXTRA_FILESYSTEMS)

  (assertEqual
    "beszel agent environmentFile"
    config.sops.templates."beszel-agent.env".path
    config.services.beszel.agent.environmentFile)

  (assertEqual
    "beszel agent smartmon"
    true
    config.services.beszel.agent.smartmon.enable)

  (assertEqual
    "beszel agent DynamicUser"
    true
    config.systemd.services.beszel-agent.serviceConfig.DynamicUser)

  (assertEqual
    "beszel agent Restart"
    "on-failure"
    config.systemd.services.beszel-agent.serviceConfig.Restart)

  (assertContains
    "beszel agent wantedBy"
    "multi-user.target"
    config.systemd.services.beszel-agent.wantedBy)

  (assertContains
    "beszel agent after"
    "network-online.target"
    config.systemd.services.beszel-agent.after)

  (assertContains
    "beszel agent disk group"
    "disk"
    config.systemd.services.beszel-agent.serviceConfig.SupplementaryGroups)
]
