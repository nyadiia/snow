{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./starship
  ];

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      shellInit = ''
        any-nix-shell fish --info-right | source
        set --universal zoxide_cmd cd
      '';
      shellAliases = {
        s = "ssh";
        cl = "clear";
        l = "ls";
        la = "ls -al";
        ll = "ls -l";
        lr = "ls -R";
      };
      plugins = [
        {
          name = "autopair";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
            hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
          };
        }
      ];
    };
    zoxide.enable = true;
    fzf.enable = true;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      icons = "auto";
    };
  };
}
