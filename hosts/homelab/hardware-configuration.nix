{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "xhci_pci"
    "ehci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  boot.kernelModules = [
    "kvm-intel"
    "i915"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4fb5e617-69a8-4358-8078-becef55d6598";
    fsType = "ext4";
    options = [ "errors=remount-ro" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/FD62-E6A2";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  fileSystems."/mnt/myraid" = {
    device = "/dev/disk/by-uuid/f316b340-b988-4306-8164-9f7d11250a55";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/2f26abd3-1603-4c8d-890c-a8a8aea9c5f1";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/a1cc6a0f-053e-4b14-9558-3d39a6f34a93";
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}