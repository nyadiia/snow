{ inputs, pkgs, ... }:
{
  programs.ironbar = {
    enable = true;
    package = inputs.ironbar.packages.${pkgs.system}.ironbar;
  };
}
