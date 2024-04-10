{ config, lib, pkgs, inputs, ... }:

{
  options.hm = {
    imports = lib.mkOption {
      type = lib.types.listOf lib.types.nonEmptyStr;
      default = [];
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${config.custom.user.name} = {
      imports = inputs.home-manager.nixosModules.home-manager
        ++ config.hm.imports;
      home = {
        username = config.system.user.name;
        homeDirectory = "/home/${config.custom.user.name}";
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
        userName = config.custom.user.name;
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
