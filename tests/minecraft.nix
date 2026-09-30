{ config, pkgs, helpers, ... }:

with helpers;

[
  (assertEqual
    "Minecraft service enabled"
    true
    config.systemd.services.minecraft.enable)

  (assertEqual
    "Minecraft service user"
    "minecraft"
    config.systemd.services.minecraft.serviceConfig.User)

  (assertEqual
    "Minecraft service group"
    "minecraft"
    config.systemd.services.minecraft.serviceConfig.Group)

  (assertEqual
    "Minecraft working directory"
    "/var/lib/minecraft"
    config.systemd.services.minecraft.serviceConfig.WorkingDirectory)

  (assertEqual
    "Minecraft Java runtime"
    "${pkgs.jdk21}/bin/java"
    (builtins.elemAt
      (builtins.match "([^ ]+) -Xms2048M.*" config.systemd.services.minecraft.serviceConfig.ExecStart)
      0))

  (assertEqual
    "Minecraft minimum heap"
    true
    (builtins.match ".*-Xms2048M.*" config.systemd.services.minecraft.serviceConfig.ExecStart != null))

  (assertEqual
    "Minecraft maximum heap"
    true
    (builtins.match ".*-Xmx4096M.*" config.systemd.services.minecraft.serviceConfig.ExecStart != null))

  (assertEqual
    "Minecraft server JAR"
    true
    (builtins.match ".*/opt/minecraft/server\\.jar.*" config.systemd.services.minecraft.serviceConfig.ExecStart != null))

  (assertEqual
    "Minecraft nogui"
    true
    (builtins.match ".*nogui" config.systemd.services.minecraft.serviceConfig.ExecStart != null))

  (assertEqual
    "Minecraft restart policy"
    "on-failure"
    config.systemd.services.minecraft.serviceConfig.Restart)

  (assertEqual
    "Minecraft restart delay"
    10
    config.systemd.services.minecraft.serviceConfig.RestartSec)

  (assertEqual
    "Minecraft stop timeout"
    30
    config.systemd.services.minecraft.serviceConfig.TimeoutStopSec)

  (assertEqual
    "Minecraft kill signal"
    "SIGINT"
    config.systemd.services.minecraft.serviceConfig.KillSignal)
]