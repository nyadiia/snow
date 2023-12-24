{ lib, ... }:
{
  programs.zoxide.enable = true;
  programs.fish.shellAliases = lib.mkBefore {
    cd = "z";
  };
}
