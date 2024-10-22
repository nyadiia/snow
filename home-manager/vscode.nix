{ pkgs, small, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "files.autoSave" = "afterDelay";
    };
    extensions =
      with pkgs.vscode-extensions;
      [
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
        {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.5.2";
          hash = "sha256-D+SZEQQwjZeuyENOYBJGn8tqS3cJiWbEkmEqhNRY/i4=";
        }
      ];
  };
}
