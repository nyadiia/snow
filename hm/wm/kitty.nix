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

    # extraConfig = builtins.fetchurl {
    #   url = "https://raw.githubusercontent.com/hbjydev/oxocarbon-kitty/refs/heads/main/skin.conf";
    #   sha256 = "1lkm3sgmb113ywbfxl9k2ng230a1ks4is13lq89s95lp98zrqy21";
    # };
  };
}
