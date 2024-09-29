{ lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = lib.mkForce {
      font.normal = {
        family = "CozetteHiDpi";
        style = "Medium";
      };
      window.opacity = 0.8;
    };
  };
}
