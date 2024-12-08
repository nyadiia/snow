{
  ssh-keys,
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
      sshKeys = [ ssh-keys.outPath ];
    };
    syncthing.enable = true;
    deviceType = "laptop";
  };

  hm.git = {
    inherit email signingKey;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

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

}
