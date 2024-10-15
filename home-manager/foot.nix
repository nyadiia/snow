{ lib, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # term = "xterm-256color";

        font = lib.mkForce "CozetteHiDpi:size=11:style=Medium";
      };
      colors = {
        alpha = lib.mkForce 0.8;
      };
    };
  };
}
