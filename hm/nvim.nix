{ pkgs, ... }:
let
  module = import ../packages/nixvim { inherit pkgs; };
in
{
  programs.nixvim = module // {
    enable = true;
    defaultEditor = true;
  };
}
