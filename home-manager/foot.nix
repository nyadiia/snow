{ lib, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # term = "xterm-256color";
      };
      colors = {
        alpha = lib.mkForce 0.8;
      };
    };
  };
}
