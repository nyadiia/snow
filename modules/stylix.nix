{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    image = ../wallpapers/lain_lucy.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };

      serif = config.stylix.fonts.sansSerif;

      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; };
        name = "Mononoki Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };
    targets = {
      regreet.enable = false;
      console.enable = false;
      grub.enable = true;
    };
  };
}
