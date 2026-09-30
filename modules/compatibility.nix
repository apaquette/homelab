{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      glibc
      libgcc
      stdenv.cc.cc
    ];
  };
}