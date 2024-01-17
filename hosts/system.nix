# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # User info
  programs = {
    fish = {
      enable = true;
      promptInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };
    gnupg.agent.enable = true;
    dconf.enable = true;
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
  };


  environment.systemPackages = with pkgs; [
    tmux
    neovim
    wget
    curl
    usbutils
    links2
    ripgrep
    any-nix-shell
    neofetch

    # not really needed on desktop (home-manager handles it) but nice for servers
    git
    delta

    # iphone bs
    libimobiledevice
    idevicerestore
    ifuse

    # fs
    ntfs3g
    zip unzip
  ];

  services = { 
    # TODO: remember to login to tailscale!! 
    # sorry this isn't declaritive but i'm not putting api keys on github :)
    tailscale.enable = true;
    # iphone stuff
    usbmuxd.enable = true;
    usbmuxd.package = pkgs.usbmuxd2;

    dbus = { 
      enable = true;
      packages = [ pkgs.dconf ];
    };

    syncthing = {
      enable = true;
      user = "nyadiia";
      dataDir = "/home/nyadiia/Documents";    # Default folder for new synced folders
      configDir = "/home/nyadiia/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  users.users.nyadiia = {
    isNormalUser = true;
    home = "/home/nyadiia";
    # for systems that don't use home-manager ( like servers )
    shell = pkgs.fish;
    # !! please use home-manager if you can !!
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUjzKy5ccDe6Ij8zQG3/zqIjoKwo3kfU/0Ui50hZs+r"
    ];
  };

  # Fonts config
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;  [
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
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/Chicago";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  system.stateVersion = "23.11";
}
