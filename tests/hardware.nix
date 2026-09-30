{ config, helpers, ... }:

[
  (helpers.assertEqual
    "root filesystem device"
    "/dev/disk/by-uuid/4fb5e617-69a8-4358-8078-becef55d6598"
    config.fileSystems."/".device)

  (helpers.assertEqual
    "root filesystem type"
    "ext4"
    config.fileSystems."/".fsType)

  (helpers.assertContains
    "root filesystem options"
    "errors=remount-ro"
    config.fileSystems."/".options)

  (helpers.assertEqual
    "EFI filesystem device"
    "/dev/disk/by-uuid/FD62-E6A2"
    config.fileSystems."/boot/efi".device)

  (helpers.assertEqual
    "EFI filesystem type"
    "vfat"
    config.fileSystems."/boot/efi".fsType)

  (helpers.assertContains
    "EFI filesystem options"
    "umask=0077"
    config.fileSystems."/boot/efi".options)

  (helpers.assertEqual
    "myraid filesystem device"
    "/dev/disk/by-uuid/f316b340-b988-4306-8164-9f7d11250a55"
    config.fileSystems."/mnt/myraid".device)

  (helpers.assertEqual
    "myraid filesystem type"
    "ext4"
    config.fileSystems."/mnt/myraid".fsType)

  (helpers.assertContains
    "myraid filesystem options"
    "nofail"
    config.fileSystems."/mnt/myraid".options)

  (helpers.assertEqual
    "backup filesystem device"
    "/dev/disk/by-uuid/2f26abd3-1603-4c8d-890c-a8a8aea9c5f1"
    config.fileSystems."/mnt/backup".device)

  (helpers.assertEqual
    "backup filesystem type"
    "ext4"
    config.fileSystems."/mnt/backup".fsType)

  (helpers.assertContains
    "backup filesystem options"
    "nofail"
    config.fileSystems."/mnt/backup".options)

  (helpers.assertEqual
    "swap device"
    "/dev/disk/by-uuid/a1cc6a0f-053e-4b14-9558-3d39a6f34a93"
    (builtins.head config.swapDevices).device)

  (helpers.assertContains
    "initrd NVMe module"
    "nvme"
    config.boot.initrd.availableKernelModules)

  (helpers.assertContains
    "initrd AHCI module"
    "ahci"
    config.boot.initrd.availableKernelModules)

  (helpers.assertContains
    "initrd USB storage module"
    "usb_storage"
    config.boot.initrd.availableKernelModules)

  (helpers.assertContains
    "initrd HID module"
    "usbhid"
    config.boot.initrd.availableKernelModules)

  (helpers.assertContains
    "kernel Intel KVM module"
    "kvm-intel"
    config.boot.kernelModules)

  (helpers.assertContains
    "kernel Intel graphics module"
    "i915"
    config.boot.kernelModules)

  (helpers.assertEqual
    "systemd-boot enabled"
    true
    config.boot.loader.systemd-boot.enable)

  (helpers.assertEqual
    "EFI variables enabled"
    true
    config.boot.loader.efi.canTouchEfiVariables)

  (helpers.assertEqual
    "host platform system"
    "x86_64-linux"
    config.nixpkgs.hostPlatform.system)
]