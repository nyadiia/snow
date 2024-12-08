{ pkgs, ... }:
let
  wallpaper = "${../../wallpapers/lain_lucy.jpg}";
in
{
  services.hyprpaper = {
    enable = true;
    # package = hyprpaper.packages.${pkgs.system}.hyprpaper;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
