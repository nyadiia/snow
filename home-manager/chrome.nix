{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {
        # gruvbox-material
        id = "fjofdcgahcnlkdjapcbeonbnmjdnfcki";
      }
    ];
  };
}
