{ pkgs, nixpkgs-stable, flake-overlays, ... }:
{
  nix.buildMachines = [
    {
      hostName = "farewell";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 6;
      speedFactor = 1;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64-v3" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "vm";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 16;
      speedFactor = 3;
      supportedFeatures = [ "x86_64-linux" "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64-v3" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "garlic";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 16;
      speedFactor = 3;
      supportedFeatures = [ "x86_64-linux" "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64-v3" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86-64-v3" "gccarch-x86-64-v4" "gccarch-tigerlake" ];
#  nixpkgs.hostPlatform = {
#    gcc.arch = "x86-64-v3";
#    system = "x86_64-linux";
#  };
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
  };
  services = {
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
    # thermald.enable = true;
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
