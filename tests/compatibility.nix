{ config, pkgs, helpers, ... }:

[
  (helpers.assertEqual
    "nix-ld enabled"
    true
    config.programs.nix-ld.enable)

  (helpers.assertContains
    "nix-ld libraries"
    pkgs.glibc
    config.programs.nix-ld.libraries)

  (helpers.assertContains
    "nix-ld libraries"
    pkgs.libgcc
    config.programs.nix-ld.libraries)

  (helpers.assertContains
    "nix-ld libraries"
    pkgs.stdenv.cc.cc
    config.programs.nix-ld.libraries)
]