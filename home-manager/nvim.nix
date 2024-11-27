{ pkgs, ... }:
let
  module = import ../packages/nixvim/default.nix { inherit pkgs; };
in
{
  programs.nixvim = module // {
    enable = true;
    defaultEditor = true;
  };
}
