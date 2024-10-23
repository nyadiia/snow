{
  stylix.targets.wezterm.enable = false;
  programs.wezterm = {
    enable = false;
    # extraConfig = builtins.readFile ./wezterm.lua;
  };
}
