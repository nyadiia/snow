{ style, ... }:
let
  hexed = builtins.mapAttrs (name: color: "#" + color);
in
{
  stylix.targets.mako.enable = false;
  services.mako =
    {
      enable = true;
      borderRadius = 3;
      borderSize = 2;
      padding = "2";
      layer = "overlay";
      font = "Roboto 12";
      progressColor = "over #${style.colors.primary}";
    }
    // (
      with style.colors;
      hexed {
        textColor = on_surface;
        backgroundColor = surface;
        borderColor = outline;
      }
    );
}
