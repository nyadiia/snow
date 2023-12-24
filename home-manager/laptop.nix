{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./gnome.nix
    ./firefox.nix
  ];

  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  };
}
