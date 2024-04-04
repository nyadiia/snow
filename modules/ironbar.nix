{ inputs, ... }:
{
  inputs.ironbar.homeManagerModules.default = {
    # And configure
    programs.ironbar = {
      enable = true;
      config = import ./config.toml;
      package = inputs.ironbar;
    };
  }
}
