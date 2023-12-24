{
  imports = [
    ./starship
    ./zoxide.nix
    ./ssh.nix
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      s = "ssh";
      cl = "clear";
      l = "ls";
      la = "ls -al";
      ll = "ls -l";
      lr = "ls -R";
    };
  };

  programs.fzf.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
