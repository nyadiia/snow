{ config, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      # my tailnet
      "hyprdash" = {
        user = "nyadiia";
      };
      "crystal-heart" = {
        user = "nyadiia";
      };
      "farewell" = {
        user = "nyadiia";
      };
      "demodash" = {
        user = "nyadiia";
      };
      "wavedash" = {
        user = "nyadiia";
      };

      # acm servers
      "argo" = {
        hostname = "128.101.131.3";
        user = "root";
      };
      "vm" = {
        hostname = "128.101.131.4";
        user = "root";
      };
      "medusa" = {
        hostname = "128.101.131.6";
        user = "nadia";
      };
      "garlic" = {
        hostname = "128.101.131.5";
        user = "potte488";
      };
      "willow" = {
        hostname = "128.101.131.7";
        user = "acm";
      };

      ## acm vms
      "acm.umn.edu" = {
        user = "root";
      };
    };
  };
}
