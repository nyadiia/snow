# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/46c29583-63b5-41c2-9002-45c0c4566d41";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-7575dd14-5a34-4696-aed8-f417b99127a2".device = "/dev/disk/by-uuid/7575dd14-5a34-4696-aed8-f417b99127a2";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/36AB-C03E";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/e67a1cf4-bf0d-4ea6-a923-3fec8a1e86d2"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
