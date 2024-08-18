{ pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    package = inputs.nadiavim.packages.${pkgs.system}.default;
    defaultEditor = true;
  };
}
