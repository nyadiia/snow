{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    nixfmt-rfc-style
    typstyle
  ];
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
  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "nvim-treesitter"
      ];
    };
  };
  extraConfigVim = ''
    highlight QuickScopePrimary guifg='#89b482' gui=underline ctermfg=155 cterm=underline
    highlight QuickScopeSecondary guifg='#d3869b' gui=underline ctermfg=81 cterm=underline
  '';
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
  };
  keymaps =
    [
      {
        action = ":Neotree focus<cr>";
        key = "<C-n>";
        mode = "n";
      }
      {
        action = ":Telescope find_files<cr>";
        key = "<C-f>";
        mode = "n";
      }
      {
        action = ":Telescope live_grep<cr>";
        key = "<C-S-f>";
        mode = "n";
      }
    ]
    # window movement
    ++ (builtins.map
      (x: {
        action = "<C-w><${x}>";
        key = "<C-${x}>";
        mode = "n";
        options.silent = true;
      })
      [
        "Up"
        "Right"
        "Down"
        "Left"
      ]
    );
  globals.mapleader = " ";
  plugins = {

    barbar.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-treesitter.enable = true;
    cmp.enable = true;
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          typst = [ "typstyle" ];
        };
        format_after_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
      };
    };
    coq-nvim = {
      enable = true;
      installArtifacts = true;
    };
    coq-thirdparty.enable = true;
    floaterm = {
      enable = true;
      keymaps.toggle = "<F7>";
    };
    gitsigns.enable = true;
    lsp-format.enable = false;
    lualine.enable = true;
    neo-tree = {
      enable = true;
      closeIfLastWindow = true;
    };
    nvim-autopairs.enable = true;
    telescope.enable = true;
    treesitter = {
      enable = true;
      settings = {
        auto_install = true;
        grammerPackages = [ pkgs.tree-sitter-grammars.tree-sitter-nu ];
      };
      nixvimInjections = false;
    };
    trouble.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        markdown_oxide.enable = true;
        nil_ls.enable = true;
        nixd.enable = true;
        nushell.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        ts_ls.enable = true;
        typst_lsp.enable = true;
      };
    };
  };
}
