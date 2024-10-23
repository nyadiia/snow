{
  imports = [
    ./hyprland.nix
    ./mako.nix
    ./fcitx.nix
    ./gtk.nix
    ./fuzzel.nix
    ./ironbar.nix
    ./foot.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

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
    GDK_SCALE = "2";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ANKI_WAYLAND = "1";
  };
}
