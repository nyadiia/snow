{
  pkgs,
  zen,
  ...
}:
{
  imports = [
    ./shell
    ./nvim.nix
  ];

  programs = {
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.packages = with pkgs; [
    zen.packages.${pkgs.system}.specific
    libreoffice-fresh
    anki
    imv
    mpv
    spotify
    nixfmt-rfc-style
    playerctl
    libqalculate
    qalculate-gtk
  ];
}
