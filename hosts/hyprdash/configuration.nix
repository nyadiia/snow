{ pkgs, flake-overlays, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = "hyprdash";

  nixpkgs.overlays = [
    (self: super: {
      blas = super.blas.override {
        blasProvider = self.mkl;
      };

       lapack = super.lapack.override {
         lapackProvider = self.mkl;
       };
     })
   ] ++ flake-overlays;

  # User info
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; lib.mkAfter [
    bluetuith
    framework-tool
    wineWowPackages.waylandFull
  ];

  programs = {
    hyprland.enable = true;
    virt-manager.enable = true;
    seahorse.enable = true;
    light.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    steam.enable = true;
    steam.gamescopeSession.enable = true;
  };

  security.polkit.enable = true;

  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video" "wheel" "libvirtd" "docker" ];
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # powerManagement.powertop.enable = true;
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

  security.rtkit.enable = true;
  security.pam.services = {
    "sudo".fprintAuth = true;
    "su".fprintAuth = true;
    greetd.enableGnomeKeyring = true;
  };
  services = {
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks -r --cmd Hyprland";
        user = "greeter";
      };
    };

    # framework specific services
    fwupd.enable = true;
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
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    psd.enable = true;
  };

  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nowatchdog"
  ];
}
