{
  pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../wallpapers/camping.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };

      serif = config.stylix.fonts.sansSerif;

      # serif = {
      #   package = pkgs.roboto-serif;
      #   name = "Roboto Serif";
      # };
      #
      # monospace = {
      #   package = azuki-pkgs.azuki;
      #   name = "azuki_font";
      # };

      # sansSerif = {
      #   package = pkgs.roboto;
      #   name = "Roboto";
      # };

      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        name = "FiraCode Nerd Font";
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
  };
}
