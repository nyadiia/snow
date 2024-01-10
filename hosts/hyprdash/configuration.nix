{ config, pkgs, unstable, ... }:

{
  nix.buildMachines = [ {
    hostName = "farewell";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    # if the builder supports building for multiple architectures, 
    # replace the previous line by, e.g.
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 8;
    speedFactor = 2;
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
    speedFactor = 5;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64-v3" ];
    mandatoryFeatures = [ ];
  }
  ];
  nix.distributedBuilds = false;
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

  # User info
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  programs = {
    virt-manager.enable = true;
    light.enable = true;
  };

  security.polkit.enable = true;

  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video" "wheel" "libvirtd" ];
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

  # disable pulseaudio and enable pipewire
  hardware.pulseaudio.enable = false;
  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };

    # framework specific services
    fwupd.enable = true;

    # general services
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
