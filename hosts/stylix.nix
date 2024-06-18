{ pkgs, ... }:
{
  stylix = {
    image = ../wallpapers/flodded_road.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
  
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
  
      monospace = {
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode"]; });
        name = "FiraCode Nerd Font";
      };
  
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };
  };
}
