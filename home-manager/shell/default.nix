{
  imports = [
    ./starship
    ./zoxide.nix
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
}