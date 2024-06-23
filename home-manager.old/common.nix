{ pkgs, ... }:

{
  imports = [ ./shell ];

  home.username = "nyadiia";
  home.homeDirectory = "/home/nyadiia";

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    delta.enable = true;
    userName = "nyadiia";
    userEmail = "nyadiia@pm.me";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
    };
    signing = {
      signByDefault = true;
      key = "C8DC17070AC33338193F9723229718FDC160E880";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [
        "qemu:///system"
        "qemu+ssh://root@vm/system"
        "qemu+ssh://root@argo/system"
      ];
      uris = [
        "qemu:///system"
        "qemu+ssh://root@vm/system"
        "qemu+ssh://root@argo/system"
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home = {
    stateVersion = "23.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
