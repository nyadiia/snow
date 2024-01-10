{ inputs, ... }:
{
  inputs.ironbar.homeManagerModules.default = {
    # And configure
    programs.ironbar = {
      enable = true;
      config = {};
      style = "";
      package = inputs.ironbar;
      features = ["feature" "another_feature"];
    };
  }
}
