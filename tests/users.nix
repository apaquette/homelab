{ config, helpers, ... }:

with helpers;

[
  (assertEqual "apaquette UID" 1000 config.users.users.apaquette.uid)
  (assertEqual "apaquette primary group" "apaquette" config.users.users.apaquette.group)
  (assertEqual "apaquette GID" 1000 config.users.groups.apaquette.gid)

  (assertEqual "www-data UID" 33 config.users.users."www-data".uid)
  (assertEqual "www-data GID" 33 config.users.groups."www-data".gid)

  (assertEqual
  "radarr user has media access"
  true
  (builtins.elem
    "apaquette"
    config.users.users.radarr.extraGroups))

  (assertEqual "sonarr user has media access" true
     (builtins.elem "apaquette" config.users.users.sonarr.extraGroups)
  )

  (assertEqual "qbittorrent UID" 104 config.users.users.qbittorrent.uid)
  (assertEqual "qbittorrent GID" 106 config.users.groups.qbittorrent.gid)

  (assertEqual "jellyfin UID" 105 config.users.users.jellyfin.uid)
  (assertEqual "jellyfin GID" 107 config.users.groups.jellyfin.gid)

  (assertEqual "minecraft UID" 997 config.users.users.minecraft.uid)
  (assertEqual "minecraft GID" 988 config.users.groups.minecraft.gid)

  (assertEqual "jenkins-deploy UID" 1001 config.users.users.jenkins-deploy.uid)
  (assertEqual "jenkins-deploy GID" 1001 config.users.groups.jenkins-deploy.gid)
]
