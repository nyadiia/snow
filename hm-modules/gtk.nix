{ lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = lib.mkDefault "gruvbox-dark";
      package = lib.mkDefault pkgs.gruvbox-dark-gtk;
    };
    iconTheme = {
      name = lib.mkDefault "oomox-gruvbox-dark";
      package = lib.mkDefault pkgs.gruvbox-dark-icons-gtk;
    };
  };
}
