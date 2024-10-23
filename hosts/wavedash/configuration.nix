# {
#   config,
#   pkgs,
#   unstable,
#   inputs,
#   ...
# }:
# {
#   nix.buildMachines = [
#     {
#       hostName = "farewell";
#       system = "x86_64-linux";
#       protocol = "ssh-ng";
#       # if the builder supports building for multiple architectures, 
#       # replace the previous line by, e.g.
#       # systems = ["x86_64-linux" "aarch64-linux"];
#       maxJobs = 8;
#       speedFactor = 2;
#       supportedFeatures = [
#         "nixos-test"
#         "benchmark"
#         "big-parallel"
#         "kvm"
#         "gccarch-x86_64-v3"
#       ];
#       mandatoryFeatures = [ ];
#     }
#     {
#       hostName = "vm";
#       system = "x86_64-linux";
#       protocol = "ssh-ng";
#       # if the builder supports building for multiple architectures, 
#       # replace the previous line by, e.g.
#       # systems = ["x86_64-linux" "aarch64-linux"];
#       maxJobs = 16;
#       speedFactor = 5;
#       supportedFeatures = [
#         "nixos-test"
#         "benchmark"
#         "big-parallel"
#         "kvm"
#         "gccarch-x86_64-v3"
#       ];
#       mandatoryFeatures = [ ];
#     }
#   ];
#   nix.distributedBuilds = false;
#   # optional, useful when the builder has a faster internet connection than yours
#   nix.extraOptions = ''
#     builders-use-substitutes = true
#   '';

#   nix.settings.system-features = [
#     "nixos-test"
#     "benchmark"
#     "big-parallel"
#     "kvm"
#     "gccarch-x86-64-v3"
#     "gccarch-x86-64-v4"
#     "gccarch-tigerlake"
#   ];
#   #  nixpkgs.hostPlatform = {
#   #    gcc.arch = "x86-64-v4";
#   #    system = "x86_64-linux";
#   #  };
#   networking.networkmanager.enable = true;
#   networking.hostName = "wavedash";

#   # User info
#   nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

#   programs = {
#     virt-manager.enable = true;
#     seahorse.enable = true;
#     light.enable = true;
#     thunar = {
#       enable = true;
#       plugins = with pkgs.xfce; [
#         thunar-archive-plugin
#         thunar-volman
#       ];
#     };
#     steam.enable = true;
#     steam.gamescopeSession.enable = true;
#   };

#   security.polkit.enable = true;

#   users.users.nyadiia = {
#     extraGroups = [
#       "networkmanager"
#       "video"
#       "wheel"
#       "libvirtd"
#       "docker"
#     ];
#   };

#   systemd.services.greetd.serviceConfig = {
#     Type = "idle";
#     StandardInput = "tty";
#     StandardOutput = "tty";
#     StandardError = "journal"; # Without this errors will spam on screen
#     # Without these bootlogs will spam on screen
#     TTYReset = true;
#     TTYVHangup = true;
#     TTYVTDisallocate = true;
#   };

#   # Enable OpenGL
#   hardware.opengl = {
#     enable = true;
#     driSupport = true;
#     driSupport32Bit = true;
#   };

#   # Load nvidia driver for Xorg and Wayland
#   services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470 etc.

#   hardware.nvidia = {
#     package = config.boot.kernelPackages.nvidiaPackages.stable;
#     modesetting.enable = true;
#     nvidiaSettings = true;

#     # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
#     # Enable this if you have graphical corruption issues or application crashes after waking
#     # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
#     # of just the bare essentials.
#     powerManagement.enable = false;

#     # Fine-grained power management. Turns off GPU when not in use.
#     # Experimental and only works on modern Nvidia GPUs (Turing or newer).
#     powerManagement.finegrained = false;
#   };

#   # disable pulseaudio and enable pipewire
#   hardware.pulseaudio.enable = false;
#   security.rtkit.enable = true;
#   services = {
#     greetd = {
#       enable = true;
#       settings.default_session = {
#         command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
#         user = "greeter";
#       };
#     };

#     # general services
#     printing.enable = true;
#     pipewire = {
#       enable = true;
#       alsa.enable = true;
#       alsa.support32Bit = true;
#       pulse.enable = true;
#     };
#     gvfs.enable = true; # Mount, trash, and other functionalities
#     tumbler.enable = true; # Thumbnail support for images
#   };

#   boot.kernelParams = [ "mem_sleep_default=deep" ];
# }
