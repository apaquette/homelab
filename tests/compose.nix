{ config, pkgs, helpers, ... }:

let
  composeServices = [
    "nextcloud-compose"
    "immich-compose"
    "beszel-compose"
    "uptime-kuma-compose"
    "jenkins-compose"
  ];

  service = name: config.systemd.services.${name};

  assertCommonService = name:
    [
      (helpers.assertEqual
        "${name} Type"
        "oneshot"
        (service name).serviceConfig.Type)

      (helpers.assertEqual
        "${name} RemainAfterExit"
        true
        (service name).serviceConfig.RemainAfterExit)

      (helpers.assertEqual
        "${name} ExecStart"
        "${pkgs.docker-compose}/bin/docker-compose up -d"
        (service name).serviceConfig.ExecStart)

      (helpers.assertEqual
        "${name} ExecStop"
        "${pkgs.docker-compose}/bin/docker-compose down"
        (service name).serviceConfig.ExecStop)

      (helpers.assertContains
        "${name} wantedBy"
        "multi-user.target"
        (service name).wantedBy)

      (helpers.assertContains
        "${name} after"
        "docker.service"
        (service name).after)

      (helpers.assertContains
        "${name} requires"
        "docker.service"
        (service name).requires)
    ];

  commonTests = builtins.concatLists (
    map assertCommonService composeServices
  );

  storageTests = [
    (helpers.assertContains
      "nextcloud-compose after"
      "mnt-myraid.mount"
      (service "nextcloud-compose").after)

    (helpers.assertContains
      "nextcloud-compose requires"
      "mnt-myraid.mount"
      (service "nextcloud-compose").requires)

    (helpers.assertContains
      "immich-compose after"
      "mnt-myraid.mount"
      (service "immich-compose").after)

    (helpers.assertContains
      "immich-compose requires"
      "mnt-myraid.mount"
      (service "immich-compose").requires)

    (helpers.assertContains
      "beszel-compose after"
      "mnt-backup.mount"
      (service "beszel-compose").after)

    (helpers.assertContains
      "beszel-compose after"
      "mnt-myraid.mount"
      (service "beszel-compose").after)

    (helpers.assertContains
      "beszel-compose requires"
      "mnt-backup.mount"
      (service "beszel-compose").requires)

    (helpers.assertContains
      "beszel-compose requires"
      "mnt-myraid.mount"
      (service "beszel-compose").requires)
  ];

  workingDirectoryTests = [
    (helpers.assertEqual
      "nextcloud-compose working directory"
      "/opt/nextcloud"
      (service "nextcloud-compose").serviceConfig.WorkingDirectory)

    (helpers.assertEqual
      "immich-compose working directory"
      "/opt/immich"
      (service "immich-compose").serviceConfig.WorkingDirectory)

    (helpers.assertEqual
      "beszel-compose working directory"
      "/opt/beszel"
      (service "beszel-compose").serviceConfig.WorkingDirectory)

    (helpers.assertEqual
      "uptime-kuma-compose working directory"
      "/opt/uptime-kuma"
      (service "uptime-kuma-compose").serviceConfig.WorkingDirectory)

    (helpers.assertEqual
      "jenkins-compose working directory"
      "/opt/jenkins"
      (service "jenkins-compose").serviceConfig.WorkingDirectory)
  ];

  secretTests = [
    (helpers.assertEqual
      "nextcloud-compose EnvironmentFile"
      config.sops.templates."nextcloud.env".path
      (service "nextcloud-compose").serviceConfig.EnvironmentFile)

    (helpers.assertEqual
      "immich-compose EnvironmentFile"
      config.sops.templates."immich.env".path
      (service "immich-compose").serviceConfig.EnvironmentFile)

    (helpers.assertEqual
      "beszel-compose EnvironmentFile"
      config.sops.templates."beszel.env".path
      (service "beszel-compose").serviceConfig.EnvironmentFile)
  ];

  noSecretEnvironmentTests = [
    (helpers.assertEqual
      "uptime-kuma-compose has no EnvironmentFile"
      null
      (service "uptime-kuma-compose").serviceConfig.EnvironmentFile or null)

    (helpers.assertEqual
      "jenkins-compose has no EnvironmentFile"
      null
      (service "jenkins-compose").serviceConfig.EnvironmentFile or null)
  ];

in
commonTests
++ storageTests
++ workingDirectoryTests
++ secretTests
++ noSecretEnvironmentTests
