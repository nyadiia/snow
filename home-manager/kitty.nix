{ lib, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      placement_strategy = "top-left";
      confirm_os_window_close = "0";
      background_opacity = lib.mkForce "0.8";
      background = lib.mkForce "#000000";
    };
  };
}
