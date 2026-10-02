{ config, pkgs, helpers, ... }:

with helpers;
[
(assertEqual
  "Minecraft uses declarative configuration"
  true
  config.services.minecraft-server.declarative)

(assertEqual
  "Minecraft server port"
  4300
  config.services.minecraft-server.serverProperties.server-port)

(assertEqual
  "Minecraft query enabled"
  true
  config.services.minecraft-server.serverProperties.enable-query)

(assertEqual
  "Minecraft query port"
  25565
  config.services.minecraft-server.serverProperties."query.port")

(assertEqual
  "Minecraft difficulty"
  "normal"
  config.services.minecraft-server.serverProperties.difficulty)

(assertEqual
  "Minecraft gamemode"
  "survival"
  config.services.minecraft-server.serverProperties.gamemode)

(assertEqual
  "Minecraft max players"
  5
  config.services.minecraft-server.serverProperties.max-players)

(assertEqual
  "Minecraft MOTD"
  "Alex's Minecraft server!"
  config.services.minecraft-server.serverProperties.motd)

(assertEqual
  "Minecraft whitelist enabled"
  true
  config.services.minecraft-server.serverProperties."white-list")

(assertEqual
  "Minecraft online mode"
  true
  config.services.minecraft-server.serverProperties."online-mode")

(assertEqual
  "Minecraft view distance"
  10
  config.services.minecraft-server.serverProperties."view-distance")

(assertEqual
  "Minecraft simulation distance"
  10
  config.services.minecraft-server.serverProperties."simulation-distance")

(assertEqual
  "Minecraft allow cheats"
  true
  config.services.minecraft-server.serverProperties."allow-cheats")

(assertEqual
  "Minecraft generate structures"
  true
  config.services.minecraft-server.serverProperties."generate-structures")

(assertEqual
  "Minecraft level name"
  "world"
  config.services.minecraft-server.serverProperties."level-name")
(assertEqual
  "Minecraft whitelist configured"
  true
  (config.services.minecraft-server.whitelist != null))
]
