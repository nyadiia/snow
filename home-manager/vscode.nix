{ pkgs, small, ... }:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      files.autoSave = "afterDelay";
      "[typescript]" = {
        editor.defaultFormatter = "esbenp.prettier-vscode";
      };
      # nix = {
      #   enableLanguageServer = true;
      #   serverPath = "nixd";
      #   serverSettings = {
      #     nixd = {
      #       formatting = {
      #         command = [ "nixfmt" ];
      #       };
      #       options = {
      #         # By default, this entry will be read from `import <nixpkgs> { }`.
      #         # You can write arbitrary Nix expressions here, to produce valid "options" declaration result.
      #         # Tip = for flake-based configuration, utilize `builtins.getFlake`
      #         nixos.expr = "(builtins.getFlake \"/absolute/path/to/flake\").nixosConfigurations.<name>.options";
      #         home-manager.expr = "(builtins.getFlake \"/absolute/path/to/flake\").homeConfigurations.<name>.options";
      #         # "packages" = {
      #         #     "expr" = "(builtins.getFlake \"/absolute/path/to/flake\").packages.<system>.<name>.options";
      #         # };
      #         # Tip = use ${workspaceFolder} variable to define path
      #         # "nix-darwin" = {
      #         #   "expr" = "(builtins.getFlake \"\${workspaceFolder}/path/to/flake\").darwinConfigurations.<name>.options";
      #         # };
      #       };
      #     };
      #   };
      # };
    };
    extensions =
      with pkgs.vscode-extensions;
      [
        christian-kohler.path-intellisense
        ms-python.python
        ms-toolsai.jupyter
        (small.pkgs.vscode-extensions.rust-lang.rust-analyzer)
        serayuzgur.crates
        ms-vscode.cpptools
        ecmel.vscode-html-css

        jnoortheen.nix-ide
        mkhl.direnv
        marp-team.marp-vscode
        yzhang.markdown-all-in-one
        tamasfe.even-better-toml
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss

        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        github.copilot
        mvllow.rose-pine
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "html-snippets";
          publisher = "abusaidm";
          version = "0.2.1";
          hash = "sha256-mps1lMruuA6cb4kae0J3bMNJPb1uIQAb7jjy9aDn2Oc=";
        }
        {
          name = "five-server";
          publisher = "yandeu";
          version = "0.3.1";
          hash = "sha256-C0dzedKMH2tgospzS+o1eqBmNYEKurEOTPbt0t+22t8=";
        }
      ];
  };
}
