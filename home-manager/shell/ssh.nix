{ config, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # my tailnet
      "hyprdash" = {
        hostname = "100.106.53.95";
        user = "nyadiia";
      };
      "crystal-heart" = {
        hostname = "100.88.38.130";
        user = "nyadiia";
      };
      "farewell" = {
        hostname = "100.122.216.134";
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

      # localhost only
      "balsam" = {
        hostname = "10.0.100.227";
        user = "nyadiia";
      };
    };

  };
}
