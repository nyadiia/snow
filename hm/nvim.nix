{ pkgs, ... }:
let
  module = import ../packages/nixvim/nixvim.nix;
in
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      typstyle
    ];

    plugins.treesitter.settings.grammarPackages = [ pkgs.tree-sitter-grammars.tree-sitter-nu ];

    colorscheme = "gruvbox-material";
    extraPlugins = with pkgs.vimPlugins; [
      gruvbox-material-nvim
      quick-scope
    ];
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
    '';
  } // module;
}
