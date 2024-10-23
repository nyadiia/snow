{ pkgs, small, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      delta.enable = true;
      delta.package = small.delta;
      userName = "nyadiia";
      userEmail = "nyadiia@pm.me";
      extraConfig = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        feature.manyFiles = true;
      };
      signing = {
        signByDefault = true;
        key = "178B4B1243860873";
      };
    };
    btop.enable = true;
    bat = {
      enable = true;
      themes = {
        gruvbox-material = {
          src = pkgs.fetchFromGitHub {
            owner = "karimlevallois";
            repo = "gruvbox-material-sublime-text";
            rev = "f37e5b0b89c78d2121daff6f82e6a244a25b7e84";
            hash = "sha256-PU483frm8O9Z2xHddzdbt6SAg80TZkv1JYfe9A+UoIA=";
          };
        };
      };
    };
    fd.enable = true;
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
      SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
