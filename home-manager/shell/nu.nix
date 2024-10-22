{
  imports = [
    ./ssh.nix
    ./starship
  ];

  programs = {
    carapace.enable = true;
    nix-index.enable = true;
    nushell = {
      enable = true;
      configFile.text = (builtins.readFile ./config.nu) + "\n" + (builtins.readFile ./zoxide.nu);
      shellAliases = {
        s = "ssh";
        cl = "clear";
        l = "ls";
        la = "ls -al";
        ll = "ls -l";
      };
    };
    zoxide.enable = true;
    fzf = {
      enable = true;
      fileWidgetOptions = [ "--preview 'bat{}'" ];
    };
  };
}
