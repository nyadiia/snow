{ inputs, pkgs, ... }:
{
  programs.anyrun = {
    enable = true;
    package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.dictionary
      ];
      width = { fraction = 0.3; };
    };
  };
}
