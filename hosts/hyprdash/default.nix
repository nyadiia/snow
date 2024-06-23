{ ... }:
{
  imports = [
    ../system.nix
    ../home.nix
    ./hardware-configuration.nix
  ];
  nixpkgs.overlays = [
    (self: super: {
      blas = super.blas.override { blasProvider = self.mkl; };

      lapack = super.lapack.override { lapackProvider = self.mkl; };
    })
  ];
  networking.hostName = "hyprdash";
  custom = {
    user = {
      name = "nyadiia";
      ssh-keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUjzKy5ccDe6Ij8zQG3/zqIjoKwo3kfU/0Ui50hZs+r" ];
    };
    podman.enable = true;
    nix-index.enable = true;
    # syncthing.enable = true;
    laptop = true;
  };
  programs.nh.flake = "/home/nyadiia/snow";
}
