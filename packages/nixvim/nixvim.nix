{
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
    coq-nvim = {
      enable = true;
      installArtifacts = true;
    };
    coq-thirdparty.enable = true;
    cmp.enable = true;
    cmp-treesitter.enable = true;
    cmp-nvim-lsp.enable = true;
    barbar.enable = true;
    nvim-autopairs.enable = true;
    lsp-format.enable = false;
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
    treesitter = {
      enable = true;
      settings.auto_install = true;
    };
    gitsigns.enable = true;
    floaterm = {
      enable = true;
      keymaps.toggle = "<F7>";
    };
    flash.enable = true;
    which-key.enable = true;
    trouble.enable = true;
    telescope.enable = true;
    web-devicons.enable = true;
    # lz-n.enable = true;
    lualine.enable = true;
    neo-tree = {
      enable = true;
      closeIfLastWindow = true;
    };
    lsp = {
      enable = true;
      servers = {
        typst_lsp.enable = true;
        nil_ls.enable = true;
        nixd.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        markdown_oxide.enable = true;
        ts_ls.enable = true;
      };
    };
  };
  performance = {
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "nvim-treesitter"
      ];
    };
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      plugins = true;
    };
  };
}
