{ pkgs, small, ... }:

{
  imports = [
    ./common.nix
    ./firefox.nix
    # ./chrome.nix
    ./vscode.nix
    ./nvim.nix
    ./hyprland.nix
    ./fcitx.nix
    ./alacritty.nix
    ./foot.nix
    ./xcompose.nix
  ];

  programs = {
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.packages = with pkgs; [
    # cargo
    # rustc
    vlc
    zathura
    brave
    libreoffice-fresh
    # neovim
    yubioath-flutter
    small.proton-pass
    anki
    imv
    mpv
    nil
    obsidian
    spotify
    nixpkgs-fmt
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
}
