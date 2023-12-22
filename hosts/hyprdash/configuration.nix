# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, ... }:

{
  networking.networkmanager.enable = true;
  networking.hostName = "hyprdash";

  # User info
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video"];
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

  services = {
    
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