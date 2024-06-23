{
  custom,
  flake-overlays,
  ironbar,
  ssh-keys,
  ...
}:
{
  nixpkgs.overlays = [
    (self: super: {
      blas = super.blas.override { blasProvider = self.mkl; };

      lapack = super.lapack.override { lapackProvider = self.mkl; };
    })
  ] ++ flake-overlays;

  networking.hostName = "hyprdash";
  custom = {
    user = {
      name = "nyadiia";
      ssh-keys = [ ssh-keys.outPath ];
    };
    podman.enable = true;
    nix-index.enable = true;
    syncthing.enable = true;
    laptop = true;
  };

  home-manager.users.nyadiia = {
    imports = [
      ./hm-modules/shell
      ./hm-modules/gtk.nix
      ./hm-modules/mako.nix
      ./hm-modules/fcitx.nix
      ./hm-modules/kitty.nix
      ./hm-modules/fuzzel.nix
      ./hm-modules/vscode.nix
      ./hm-modules/firefox.nix
      ./hm-modules/ironbar.nix
      ./hm-modules/hyprland.nix
      ironbar.homeManagerModules.default
    ];
    home.stateVersion = "23.11";
  };
}
