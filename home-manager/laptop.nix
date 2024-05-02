{ pkgs, stable, ... }:

{
  imports = [
    ./common.nix
    ./firefox.nix
    ./vscode.nix
    # ./nvim.nix
    ./hyprland.nix
    ./fcitx.nix
  ];

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 20;
    x11.enable = true;
    gtk.enable = true;
  };

  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";

    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  home.packages = with pkgs; [
    mpv
    nil
    (stable.obsidian)
    spotify
    nixpkgs-fmt
    vesktop
    tigervnc
    prismlauncher
    swww
    playerctl
    tofi
    wl-clipboard
    libnotify
    pavucontrol
    qalculate-gtk
    gnome.file-roller
    grimblast
    ffmpeg
    signal-desktop
    hyprlock
    rustup
    glib

    (octaveFull.withPackages (opkgs: with opkgs; [
      symbolic
      io
      ocl
      linear-algebra
      matgeom
      general
      audio
      fuzzy-logic-toolkit
      control
    ]))
  ];
}
