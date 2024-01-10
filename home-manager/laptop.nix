{ pkgs, unstable, ... }:

{
  imports = [
    ./common.nix
    ./gnome.nix
    ./firefox.nix
    ./sway.nix
    ./vscode.nix
    ./hyprland.nix
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  };

  home.packages = with pkgs; [
    mpv
    obsidian
    spotify
    nixpkgs-fmt
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = true;
    })
    tigervnc
    prismlauncher
    swww
    playerctl
    xfce.thunar
    tofi
    wl-clipboard
  ];
}
