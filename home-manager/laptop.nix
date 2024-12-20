{ pkgs, small, ... }:

{
  imports = [
    ./common.nix
    ./vscode.nix
    ./nvim.nix
    ./hyprland.nix
    ./fcitx.nix
    # ./alacritty.nix
    # ./foot.nix
    ./kitty
    ./xcompose.nix
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

  programs = {
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.packages = with pkgs; [
    networkmanagerapplet
    vlc
    zathura
    # libreoffice-fresh
    yubioath-flutter
    small.proton-pass
    anki
    imv
    mpv
    obsidian
    spotify
    nixfmt-rfc-style
    vesktop
    tigervnc
    prismlauncher
    playerctl
    tofi
    wl-clipboard
    libnotify
    pavucontrol
    libqalculate
    qalculate-gtk
    file-roller
    grimblast
    ffmpeg
    signal-desktop
    hyprlock
    rustup
    glib

    (octaveFull.withPackages (
      opkgs: with opkgs; [
        symbolic
        io
        ocl
        linear-algebra
        matgeom
        general
        audio
        control
      ]
    ))
  ];

  home.file.".octaverc" = {
    target = "/.octaverc";
    text = ''
      pkg load symbolic
      pkg load control
      pkg load audio
    '';
  };
}
