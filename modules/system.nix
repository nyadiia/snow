{
  config,
  lib,
  pkgs,
  flake,
  username,
  ...
}:

{
  options = {
    custom = {
      user = {
        sshKeys = lib.mkOption {
          type = lib.types.listOf lib.types.nonEmpty.str;
          default = [ ];
        };

        groups = lib.mkOption {
          type = lib.types.listOf lib.types.nonEmptyStr;
          default = [ ];
        };
      };

      syncthing.enable = lib.mkEnableOption {
        type = lib.types.bool;
        default = true;
      };

      deviceType = lib.mkOption {
        type = lib.types.enum [
          "desktop"
          "laptop"
          "server"
        ];
        default = "desktop";
      };
    };
    hm = {
      git = {
        email = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "";
        };
        signingKey = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    };

  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${username} = {
        home = {
          inherit (config.system) stateVersion;
          homeDirectory = "/home/${username}";
          sessionVariables =
            {
              EDITOR = "nvim";
              VISUAL = "nvim";
            }
            ++ (lib.mkIf (config.custom.deviceType != "server")) {
              SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
            };
        };
        programs = {
          gpg.enable = true;
          git = {
            enable = true;
            package = pkgs.gitAndTools.gitFull;
            delta.enable = true;
            userName = username;
            userEmail = config.hm.git.email;
            extraConfig = {
              core.editor = "nvim";
              init.defaultBranch = "main";
              feature.manyFiles = true;
            };
            signing = lib.mkIf (config.hm.git.signingKey != "") {
              signByDefault = true;
              key = config.hm.git.signingKey;
            };
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
          btop.enable = true;
          bat = {
            enable = true;
            themes = {
              gruvbox-material = {
                src = pkgs.fetchFromGitHub {
                  owner = "karimlevallois";
                  repo = "gruvbox-material-sublime-text";
                  rev = "f37e5b0b89c78d2121daff6f82e6a244a25b7e84";
                  hash = "sha256-PU483frm8O9Z2xHddzdbt6SAg80TZkv1JYfe9A+UoIA=";
                };
              };
            };
          };
          fd.enable = true;
          home-manager.enable = true;
        };

        services = {
          gpg-agent = {
            enable = true;
            enableSshSupport = true;
          };
        };

        # these are for home-manager functionality
        # don't edit these lines
        systemd.user.startServices = "sd-switch";
      };
    };

    nix = {
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
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };

    users.users.${username} = {
      isNormalUser = true;
      # group = username;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = config.custom.user.sshKeys;
      extraGroups =
        [
          "input"
          "networkmanager"
          "wheel"
        ]
        ++ (lib.optionals (config.custom.deviceType == "laptop")) [ "video" ] ++ config.custom.user.groups;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    };

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
        clean.extraArgs = "--keep-since 30d --keep 10 --nogcroots";
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
      fastfetch
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
      xserver.xkb.layout = "us";
      # TODO: remember to login to tailscale!!
      tailscale.enable = true;
      chrony.enable = true;

      # iphone stuff
      usbmuxd.enable = true;
      usbmuxd.package = pkgs.usbmuxd2;

      udisks2.enable = true;
      gvfs.enable = true;
      devmon.enable = true;
      syncthing = lib.mkIf config.custom.syncthing.enable {
        enable = true;
        user = username;
        dataDir = "/home/${username}/Documents"; # Default folder for new synced folders
        configDir = "/home/${username}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      };
      dbus = lib.mkIf (config.custom.deviceType != "server") {
        enable = true;
        packages = [ pkgs.dconf ];
      };

    };

    # Fonts config
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts-cjk-sans
        twitter-color-emoji
        (nerdfonts.override {
          fonts = [
            "Mononoki"
          ];
        })
        cozette
        corefonts
        vistafonts
        roboto
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "Roboto" ];
          sansSerif = [ "Roboto" ];
          monospace = [ "Mononoki Nerd Font" ];
        };
      };
    };

    nixpkgs.config.allowUnfree = true;

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

    # Enable virtualization
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    system.stateVersion = "23.11";
  };
}
