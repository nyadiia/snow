# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  options.custom = {
    # forces you to set a username (i think)
    user = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "";
      };

      ssh-keys = lib.mkOption {
        type = lib.types.listOf.str;
        default = [];
      };

      groups = lib.mkOption {
        type = lib.types.listOf.nonEmptyStr;
        default = [];
      };
    };

    podman.enable = lib.mkEnableOption  {
      type = lib.types.bool;
      default = false;
    };

    nix-index.enable = lib.mkEnableOption  {
      type = lib.types.bool;
      default = true;
    };

    # syncthing.enable = lib.mkEnableOption  {
    #   type = lib.types.bool;
    #   default = true;
    # };

    laptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    server = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    home-manager.sharedModules = [{
      options.custom.nix-index = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        database.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      config = {
        nix-index = lib.mkIf config.custom.nix-index.enable {
          enable = true;
          enableFishIntegration = true;
        };
      };
    }];

    users.users.${config.custom.user.name} = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = config.custom.ssh-keys;
      extraGroups = [ "networkmanager" "wheel" ] ++ lib.mkIf config.custom.laptop [ "video" ] ++ config.custom.user.groups ;
    };

    programs.command-not-found.enable = lib.mkIf config.custom.nix-index.enable false;
    programs.nix-index = lib.mkIf config.custom.nix-index.enable {
      enable = true;
      enableFishIntegration = true;
    };

    virtualisation.podman = lib.mkIf config.custom.podman.enable {
      enable = true;
      dockerCompat = true;
    };

    # programs.syncthing = lib.mkIf config.custom.syncthing.enable {
    #   enable = true;
    #   user = config.custom.user.name;
    #   dataDir = "/home/${config.custom.user.name}/Documents";    # Default folder for new synced folders
    #   configDir = "/home/${config.custom.user.name}/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
    # };

    services.dbus = lib.mkIf (!config.custom.server) {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

     networking.networkmanager.enable = true;
    # if your config errors, uncomment this
    # systemd.services.NetworkManager-wait-online.enable = false;

    security.polkit.enable = true;

    # User info
    programs = {
      fish.enable = true;
      gnupg.agent.enable = true;
      dconf.enable = true;
    };

    environment.systemPackages = with pkgs; [
      tmux
      neovim
      wget
      curl
      usbutils
      links2
      ripgrep
      neofetch
      yazi
      profile-sync-daemon

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
      usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      udisks2.enable = true;
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
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = "x86_64-linux";

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
  };
}
