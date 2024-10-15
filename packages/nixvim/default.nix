{ pkgs, ... }:
{
  imports = [
    ./nixvim.nix
  ];
  # TODO: find a way to install these packages when run using `nix run .#nvim`
  # environment.systemPackages = with pkgs; [
  #   nixfmt-rfc-style
  #   typstyle
  # ];
}
