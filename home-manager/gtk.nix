{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Pink-Dark-Compact";
      package = pkgs.orchis-theme.override {
        tweaks = [ "macos" "black" "compact" ];
      };
    };
  };
}
