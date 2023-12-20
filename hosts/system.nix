# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # User info
  programs = {
    fish.enable = true;
    gnupg.agent.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    tailscale
    git
    delta
    zellij
    usbutils
  ];

  services = { 
    # TODO: remember to login to tailscale!! sorry this isn't declaritive but i'm not putting api keys on github :)
    tailscale.enable = true;
    dbus = { 
      enable = true;
      packages = with pkgs; [ dconf ];
    };
  };

  users.users.nyadiia = {
    isNormalUser = true;
    extraGroups = [ "sudo" "libvirtd" ];
    home = "/home/nyadiia";
    shell = pkgs.fish;
    # !! please use home-manager if you can !!
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUjzKy5ccDe6Ij8zQG3/zqIjoKwo3kfU/0Ui50hZs+r"
    ];
  };

  # Fonts config
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs;  [
      noto-fonts
      noto-fonts-cjk
      twitter-color-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      cozette
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow nonfree software
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
}