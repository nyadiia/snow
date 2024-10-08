{
  pkgs,
  hyprland,
  config,
  lib,
  ...
}:
{
  networking = {
    networkmanager.enable = true;
    hostName = "hyprdash";
  };

  # User info
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  # programs.hyprlock.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages =
    (with pkgs; [
      yubikey-manager-qt
      yubikey-personalization-gui
      yubikey-personalization
      yubikey-manager

      powertop
      swtpm
      libvirt
      python3
      dnsmasq
      qemu_full
      matlab
      pavucontrol
      bluetuith
      framework-tool
      wineWowPackages.waylandFull
      polkit_gnome
      gparted
      nautilus
      fprintd
      # (pkgs.callPackage ./pentablet.nix {})
    ])
    ++ (with pkgs.gst_all_1; [
      gstreamer
      # Common plugins like "filesrc" to combine within e.g. gst-launch
      gst-plugins-base
      # Specialized plugins separated by quality
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      # Plugins to reuse ffmpeg to play almost every video format
      gst-libav
      # Support the Video Audio (Hardware) Acceleration API
      gst-vaapi
    ]);

  programs = {
    hyprland.enable = true;
    hyprland.package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    virt-manager.enable = true;
    seahorse.enable = true;
    light.enable = true;
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gnupg = {
      agent.enableSSHSupport = true;
    };
  };

  users.users.nyadiia = {
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
      "libvirtd"
      "docker"
      "vitamtp"
      "tss"
    ];
  };

  services.udev.packages = [
    pkgs.yubikey-manager-qt
    pkgs.yubikey-personalization-gui
    pkgs.yubikey-personalization
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };

  # powerManagement.powertop.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  # disable pulseaudio and enable pipewire
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services = {
      "sudo".fprintAuth = true;
      "su".fprintAuth = true;
      hyprlock.fprintAuth = false;
      greetd.enableGnomeKeyring = true;
    };
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
  services = {
    pcscd.enable = true;
    gnome.sushi.enable = true;
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      #      settings.default_session = {
      #        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks -r --cmd Hyprland";
      #        user = "greeter";
      #      };
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Welcome to PwNixOS!' --cmd Hyprland";
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks -r --cmd Hyprland";
          user = "nyadiia";
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "nyadiia";
        };
      };
    };

    # framework specific services
    # logind = {
    #   lidSwitch = "suspend-then-hibernate";
    #   extraConfig = ''
    #     HandlePowerKey=suspend-then-hibernate
    #     IdleAction=suspend-then-hibernate
    #     IdleActionSec=2m
    #   '';
    # };
    logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
        HandlePowerKey=poweroff
    '';
    fprintd.enable = true;
    fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];
      uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
    };
    blueman.enable = true;
    thermald = {
      enable = true;
      configFile = ./thermal-conf.xml;
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_MIN_ON_AC = 0;
        CPU_MAX_ON_AC = 100;
        CPU_MIN_ON_BAT = 0;
        CPU_MAX_ON_BAT = 30;
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        INTEL_GPU_MIN_FREQ_ON_AC = 100;
        INTEL_GPU_MIN_FREQ_ON_BAT = 100;
        INTEL_GPU_MAX_FREQ_ON_AC = 1300;
        INTEL_GPU_MAX_FREQ_ON_BAT = 900;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1300;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;

        NMI_WATCHDOG = 0;
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "power";
        DISK_DEVICES = "nvme0n1";
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
        WOL_DISABLE = "Y";

        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };
    upower.enable = true;

    # general services
    printing.enable = true;
    colord.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tumbler.enable = true; # Thumbnail support for images
    psd.enable = false;
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
