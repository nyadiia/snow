# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.networkmanager.enable = true;
  networking.hostName = "hyprdash";

  # User info

  nixpkgs.overlays =
    let
      vencord = self: super: {
        discord = super.discord.override { withOpenASAR = true; withVencord = true; };
      };
    in
    [ vencord ];

  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video"];
    # !! please use home-manager if you can !!
    packages = with pkgs; [
      any-nix-shell
      obsidian
      spotify
      nixpkgs-fmt
      discord
      tigervnc
      prismlauncher
    ];
  };

  # GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      # enable fractional scaling on wayland
      extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };

  # disable pulseaudio and enable pipewire
  hardware.pulseaudio.enable = false;
  services = {
    # framework specific services
    fwupd.enable = true;
    fprintd.enable = true;

    # general services
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
};