# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  flake,
  ...
}:

{
  options.custom = {
    # forces you to set a username (i think)
    user = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "";
      };

      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.nonEmpty.str;
        default = [ ];
      };

      groups = lib.mkOption {
        type = lib.types.listOf lib.types.nonEmptyStr;
        default = [ ];
      };
    };

    podman.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = false;
    };

    nix-index.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = true;
    };

    syncthing.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = true;
    };

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
    home-manager.sharedModules = [
      {
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
          programs.nix-index = lib.mkIf config.custom.nix-index.enable { enable = true; };
        };
      }
    ];

    nix = {
      package = pkgs.nixFlakes;
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
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
    };

    users.users.${config.custom.user.name} = {
      isNormalUser = true;
      # group = config.custom.user.name;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = config.custom.sshKeys;
      extraGroups = [
        "input"
        "networkmanager"
        "wheel"
      ] ++ (lib.optionals config.custom.laptop) [ "video" ] ++ config.custom.user.groups;
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

    services.syncthing = lib.mkIf config.custom.syncthing.enable {
      enable = true;
      user = config.custom.user.name;
      dataDir = "/home/${config.custom.user.name}/Documents"; # Default folder for new synced folders
      configDir = "/home/${config.custom.user.name}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };

    services.dbus = lib.mkIf (!config.custom.server) {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    networking.networkmanager.enable = true;
    # if your config errors, uncomment this
    # systemd.services.NetworkManager-wait-online.enable = false;

    security.polkit.enable = true;

    # User info
    programs = {
      fish.enable = true;
      gnupg.agent.enable = true;
      dconf.enable = true;
      nh = {
        inherit flake;
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 30d --keep 10";
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
      neofetch
      yazi
      btop

      # iphone bs
      libimobiledevice
      idevicerestore
      ifuse

      # fs
      ntfs3g
      zip
      unzip
      lz4
    ];

    services = {
      # TODO: remember to login to tailscale!!
      tailscale.enable = true;
      chrony.enable = true;

      # iphone stuff
      usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      udisks2.enable = true;
      gvfs.enable = true;
      devmon.enable = true;
    };

    # Fonts config
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
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
