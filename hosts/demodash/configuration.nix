{ config, pkgs, unstable, inputs, lib, ... }:
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

  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86-64-v2" "gccarch-sandybridge" ];

  networking.hostName = "demodash";

  # User info
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; lib.mkAfter [
    protonvpn-cli
  ];
  
  users.users.nyadiia = {
    extraGroups = ["networkmanager" "video" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUjzKy5ccDe6Ij8zQG3/zqIjoKwo3kfU/0Ui50hZs+r"
    ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # disable pulseaudio and enable pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    # transmission = { 
    #   enable = true; #Enable transmission daemon
    #   openRPCPort = true; #Open firewall for RPC
    # };

    # # framework specific services
    # fwupd.enable = true;

    # general services
    printing.enable = true;
  };
}
