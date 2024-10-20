{ pkgs, lib, ... }:
{
  imports = [
    ./nixvim.nix
  ];

  defaultEditor = true;

  # for some reason this works with home-manager but not standalone...
  performance.combinePlugins.enable = lib.mkForce false;

  # all seperate due to the way i'm also importing nixvim.nix into my home-manager config
  extraPackages = with pkgs; [
    nixfmt-rfc-style
    typstyle

  ];
  plugins.treesitter.settings.grammerPackages = [ pkgs.tree-sitter-grammars.tree-sitter-nu ];
  extraPlugins = with pkgs.vimPlugins; [
    gruvbox-material-nvim
    quick-scope
  ];
  colorscheme = "gruvbox-material";
  extraConfigLuaPre = ''
    require('gruvbox-material').setup({
      italics = true,             -- enable italics in general
      contrast = "hard",        -- set contrast, can be any of "hard", "medium", "soft"
      comments = {
    italics = true,           -- enable italic comments
      },
      background = {
    transparent = true,      -- set the background to transparent
      },
      float = {
    force_background = false, -- force background on floats even when background.transparent is set
    background_color = nil,   -- set color for float backgrounds. If nil, uses the default color set
      },
      signs = {
    highlight = true,         -- whether to highlight signs
      },
    }) 
      -- Function to get the foreground color of a highlight group
    local function get_hl_fg(group)
      local hl = vim.api.nvim_get_hl_by_name(group, true)
      if hl and hl.foreground then
    -- Return the color in #RRGGBB format
    return string.format("#%06x", hl.foreground)
      end
    end
  '';

}
