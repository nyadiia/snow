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
    };
  };
}
