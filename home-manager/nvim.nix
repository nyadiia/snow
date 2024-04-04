{ pkgs, ...}:
{
  programs.nixvim = {
    enable = true;
    # defaultEditor = true;
    colorschemes.gruvbox.enable = true;
    plugins = {
      lazy.enable = true;
      neo-tree = {
        enable = true;
      };
      neocord.enable = true;
      alpha = {
      	enable = true;
	theme = "dashboard";
      };
    };
  };
}
