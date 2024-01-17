{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 45;
        lines = 15;
      };
      colors = {
        background = "11111bcc";
        text = "a6adc8ff";
        match = "f5c2e7ff";
        selection-match = "f38ba8ff";
        selection = "313244ff";
        selection-text = "cdd6f4ff";
        border = "f5c2e7ff";
      };
    };
  };
}
