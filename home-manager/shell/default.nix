{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./tide.nix
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
          name = "zoxide";
          src = pkgs.fetchFromGitHub {
            owner = "kidonng";
            repo = "zoxide.fish";
            rev = "bfd5947bcc7cd01beb23c6a40ca9807c174bba0e";
            hash = "sha256-Hq9UXB99kmbWKUVFDeJL790P8ek+xZR5LDvS+Qih+N4=";
          };
        }
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
    zoxide = {
      enable = true;
      enableFishIntegration = false; # we're using zoxide.fish for faster init and slightly nicer results so we don't want this doing anything
    };
    fzf.enable = true;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      icons = true;
    };
    gh.enable = true;
  };
}
