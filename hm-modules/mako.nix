{ lib, ... }:
{
  services.mako = {
    enable = true;
    backgroundColor = lib.mkDefault "#282828ff";
    borderColor = lib.mkDefault "#ebdbb2ff";
    borderRadius = 3;
    borderSize = 2;
    padding = "2";
  };
}
