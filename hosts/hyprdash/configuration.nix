{ config, pkgs, unstable, ... }:

{

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
      enable = false;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
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
