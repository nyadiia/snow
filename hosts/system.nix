# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # User info
  programs = {
    fish = {
      enable = true;
      promptInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };
    ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
    ssh.startAgent = true;
    gnupg.agent.enable = true;
    dconf.enable = true;
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 10";
      flake = "/home/nyadiia/snow/";
    };
  };


  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  home-manager.backupFileExtension = "bak";

  environment.systemPackages = with pkgs; [
    nh
    tmux
    neovim
    wget
    curl
    usbutils
    links2
    ripgrep
    any-nix-shell
    fastfetch
    yazi
    profile-sync-daemon
    glib

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
    lz4
  ];

  # hardware.opentabletdriver.enable = true;

  services = {
    # TODO: remember to login to tailscale!!
    # sorry this isn't declaritive but i'm not putting api keys on github :)
    tailscale.enable = true;
    # iphone stuff
    usbmuxd.enable = true;
    usbmuxd.package = pkgs.usbmuxd2;

    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

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
      corefonts
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
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://cache.garnix.io"
        "https://hyprland.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://numtide.cachix.org"
        "https://walker.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      ];
    };
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };
  };

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
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
  services.xserver.xkb.layout = "us";

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  system.stateVersion = "23.11";
}
