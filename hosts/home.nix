{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.custom.user.name;
in
{
  options.hm = {
    git = {
      email = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "";
      };
      signingKey = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = config.system.stateVersion;
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
	  SSH_ASKPASS = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
        };
      };
      programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        delta.enable = true;
        userName = username;
        userEmail = config.hm.git.email;
        extraConfig = {
          core.editor = "nvim";
          init.defaultBranch = "main";
        };
        signing = lib.mkIf (config.hm.git.signingKey != "") {
          signByDefault = true;
          key = config.hm.git.signingKey;
        };
      };
      programs.direnv = {
	enable = true;
	nix-direnv.enable = true;
      };
      programs.btop.enable = true;
      
      # these are for home-manager functionality
      # don't edit these lines
      systemd.user.startServices = "sd-switch";
      programs.home-manager.enable = true;
    };
  };
}
