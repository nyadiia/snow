{ config, pkgs, unstable, ... }:

{
  networking.networkmanager.enable = true;
  networking.hostName = "hyprdash";

  # User info
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  programs = {
    virt-manager.enable = true;
  };

  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video" "wheel" "libvirtd" ];
    packages = with pkgs; [
      obsidian
      spotify
      nixpkgs-fmt
      (unstable.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      tigervnc
      prismlauncher
    ];
  };

  # disable pulseaudio and enable pipewire
  hardware.pulseaudio.enable = false;
  services = {
    # framework specific services
    fwupd.enable = true;

    # general services
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
