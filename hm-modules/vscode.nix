{ pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      ms-python.python
      ms-toolsai.jupyter
      rust-lang.rust-analyzer
      serayuzgur.crates
      ms-vscode.cpptools

      jnoortheen.nix-ide
      marp-team.marp-vscode
      yzhang.markdown-all-in-one
      tamasfe.even-better-toml

      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      github.copilot
    ];
  };
}
