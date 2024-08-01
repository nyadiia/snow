{ pkgs, lib, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "$TERM";
        layer = "overlay";
        width = 45;
        lines = 15;
      };
      colors = {
        background = lib.mkDefault "282828ff";
        text = lib.mkDefault "ebdbb2ff";
        match = lib.mkDefault "d65d0eff";
        selection-match = lib.mkDefault "1d2021ff";
        selection = lib.mkDefault "d65d0eff";
        selection-text = lib.mkDefault "ebdbb2ff";
        border = lib.mkDefault "ebdbb2ff";
      };
      border = {
        width = 1;
        radius = 3;
      };
    };
  };
}
