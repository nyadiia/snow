{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    yubikey-manager-qt
    yubikey-personalization-gui
    yubikey-personalization
  ];

  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    yubikey-personalization-gui
    yubikey-personalization
    yubikey-manager
  ];
}
