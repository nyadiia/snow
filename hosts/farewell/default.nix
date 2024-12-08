{
  email,
  signingKey,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  custom = {
    user = {
      groups = [ "docker" ];
    };
    syncthing.enable = true;
    deviceType = "desktop"; # technically we're a media server but there is a DE
  };

  hm.git = {
    inherit email signingKey;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      vpl-gpu-rt
      libvdpau-va-gl
    ];
    # extraPackages32 = with pkgs.pkgsi686Linux; [ vpl-gpu-rt ];
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.sessionVariables.KWIN_DRM_ALLOW_INTEL_COLORSPACE = 1;

  environment.systemPackages =
    (with pkgs; [
      virt-manager
      btop
      nvtopPackages.intel
      (pkgs.ffmpeg_7-full.override {
        withMfx = false;
        withVpl = true;
      })

      powertop
      swtpm
      libvirt
      python3
      dnsmasq
      qemu_full
      pavucontrol
      wineWowPackages.waylandFull
      gparted
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

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (_final: prev: {
      mutter = prev.mutter.overrideAttrs (_old: {
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "vanvugt";
          repo = "mutter";
          rev = "triple-buffering-v4-46";
          hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
        };
      });
    })
  ];

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
