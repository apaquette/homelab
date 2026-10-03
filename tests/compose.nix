{ config, pkgs, helpers, ... }:

let
  composeServices = [
    "nextcloud-compose"
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
  ];

  workingDirectoryTests = [
    (helpers.assertEqual
      "nextcloud-compose working directory"
      "/opt/nextcloud"
      (service "nextcloud-compose").serviceConfig.WorkingDirectory)
  ];

  secretTests = [
    (helpers.assertEqual
      "nextcloud-compose EnvironmentFile"
      config.sops.templates."nextcloud.env".path
      (service "nextcloud-compose").serviceConfig.EnvironmentFile)
  ];

in
commonTests
++ storageTests
++ workingDirectoryTests
++ secretTests
