{
  pkgs,
  azuki-pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../wallpapers/camping.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    fonts = {
      sansSerif = {
        package = azuki-pkgs.azuki;
        name = "azukifontP";
      };

      serif = config.stylix.fonts.sansSerif;

      monospace = {
        package = azuki-pkgs.azuki;
        name = "azuki_font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 14;
      };
    };
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };
  };
}
