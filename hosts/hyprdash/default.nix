{
  ssh-keys,
  email,
  signingKey,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  custom = {
    user.sshKeys = [ ssh-keys.outPath ];
    syncthing.enable = true;
    laptop = true;
  };

  hm.git = {
    inherit email signingKey;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
