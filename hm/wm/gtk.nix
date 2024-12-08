{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };
  dconf = {
    enable = false;
    #    settings = {
    #      "org/gnome/desktop/interface" = {
    #        color-scheme = "prefer-dark";
    #      };
    #    };
  };
}
