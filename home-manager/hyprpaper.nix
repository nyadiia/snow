{
  style,
  lib,
  ...
}:
let
  wallpaper = builtins.toString style.wallpaper;
in
{
  stylix.targets.hyprpaper.enable = lib.mkForce false;
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
