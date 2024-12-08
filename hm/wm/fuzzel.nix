{
  pkgs,
  # style,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        width = 45;
        lines = 15;
      };
      # colors = with style.colors; {
      #   background = surface + "ff"; # background (woag)
      #   text = on_surface + "ff"; # normal text
      #   match = primary + "ff"; # text color that matches input
      #   selection-match = primary + "ff"; # text color of selected matched characters
      #   selection = surface_variant + "ff"; # background color of selected item
      #   selection-text = on_surface + "ff"; # text color of selected item
      #   border = outline + "ff";
      # };
      border = {
        width = 1;
        radius = 3;
      };
    };
  };
}
