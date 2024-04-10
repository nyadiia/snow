{ config, lib, pkgs, inputs, ... }:

let
  username = config.custom.user.name;
in {
  options.hm = {
    imports = lib.mkOption {
      type = lib.types.listOf lib.types.nonEmptyStr;
      default = [];
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      imports = config.hm.imports;
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
    };
  };
}
