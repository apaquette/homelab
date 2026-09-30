{ pkgs, lib, config }:

let
  helpers = import ./common.nix { inherit lib; };

  tests = [
    (import ./networking.nix { inherit config helpers; })
    (import ./storage.nix { inherit config helpers; })
    (import ./users.nix { inherit config helpers; })
    (import ./docker.nix { inherit config helpers; })
    (import ./caddy.nix { inherit config helpers; })
    (import ./dnsmasq.nix { inherit config helpers; })
    (import ./jellyfin.nix { inherit config pkgs helpers; })
    (import ./media-services.nix { inherit config helpers; })
    (import ./seerr.nix { inherit config pkgs helpers; })
    (import ./minecraft.nix { inherit config pkgs helpers; })
    (import ./compose.nix { inherit config pkgs helpers; })
    (import ./sops.nix { inherit config helpers; })
    (import ./monitoring.nix { inherit config helpers; })
    (import ./backups.nix { inherit config helpers; })
    (import ./smartd.nix { inherit config helpers; })
    (import ./compatibility.nix { inherit config pkgs helpers; })
    (import ./scripts.nix { inherit config helpers; })

    # Repository structure
    (helpers.assertPathExists "flake.nix" ../flake.nix)
    (helpers.assertPathExists "homelab host" ../hosts/homelab/default.nix)
    (helpers.assertPathExists "hardware configuration" ../hosts/homelab/hardware-configuration.nix)
    (helpers.assertPathExists "users configuration" ../hosts/homelab/users.nix)

    # Scripts
    (helpers.assertPathExists "homelab-app-backup script" ../scripts/homelab-app-backup)
    (helpers.assertPathExists "homelab-backup-ntfy script" ../scripts/homelab-backup-ntfy)
    (helpers.assertPathExists "homelab-container-health script" ../scripts/homelab-container-health)
    (helpers.assertPathExists "homelab-disk-health script" ../scripts/homelab-disk-health)
    (helpers.assertPathExists "homelab-storage-health script" ../scripts/homelab-storage-health)
    (helpers.assertPathExists "homelab-storage-ntfy script" ../scripts/homelab-storage-ntfy)
    (helpers.assertPathExists "immich-backup script" ../scripts/immich-backup)
    (helpers.assertPathExists "nextcloud-backup script" ../scripts/nextcloud-backup.sh)
    (helpers.assertPathExists "smartd-ntfy script" ../scripts/smartd-ntfy)

    # Compatibility
    (helpers.assertEqual
      "nix-ld enabled"
      true
      config.programs.nix-ld.enable)

    # State version
    (helpers.assertEqual
      "NixOS state version"
      "26.05"
      config.system.stateVersion)
  ];

  flattenedTests = lib.flatten tests;
in
pkgs.runCommand "homelab-configuration-tests" {} ''
  echo "All ${toString (builtins.length flattenedTests)} configuration assertions passed."
  touch $out
''