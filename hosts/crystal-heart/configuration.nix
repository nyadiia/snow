{
  config,
  pkgs,
  unstable,
  inputs,
  lib,
  ...
}:
{
  nix.buildMachines = [
    {
      hostName = "vm";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 16;
      speedFactor = 5;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
        "gccarch-x86_64-v3"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = false;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  networking = {
    hostName = "crystal-heart";
    useDHCP = false;
    defaultGateway = "128.101.131.1";
    interfaces = {
      enp1s0.ipv4.addresses = [
        {
          address = "128.101.131.228";
          prefixLength = 24;
        }
        {
          address = "128.101.131.204";
          prefixLength = 24;
        }
      ];
    };
  };

  # User info
  security.polkit.enable = true;

  users.users.nyadiia = {
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUjzKy5ccDe6Ij8zQG3/zqIjoKwo3kfU/0Ui50hZs+r"
    ];
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
  };
}
