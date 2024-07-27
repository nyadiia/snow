{
  flake-overlays,
  ssh-keys,
  username,
  email,
  signingKey,
  ...
}:
{
  nixpkgs.overlays = flake-overlays;

  custom = {
    user = {
      name = username;
      sshKeys = [ ssh-keys.outPath ];
    };
    podman.enable = true;
    nix-index.enable = true;
    syncthing.enable = true;
    laptop = true;
  };

  hm.git = {
    inherit email signingKey;
  };
}
