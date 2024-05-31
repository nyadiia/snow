{
  imports = [
    ./starship
    ./zoxide.nix
    ./ssh.nix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
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

  programs.eza = {
    enable = true;
    icons = true;
  };
}
