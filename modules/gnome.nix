{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome
    gdm
  ];

  # GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      # enable fractional scaling on wayland
      extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}