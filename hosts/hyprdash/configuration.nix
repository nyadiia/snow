{
  custom,
  ironbar,
  flake-overlays,
  ssh-keys,
  nix-matlab,
  username,
  email,
  signingKey,
  ...
}:
{
  nixpkgs.overlays = [ ] ++ flake-overlays;

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

  hm.git = { inherit email signingKey; };
}
