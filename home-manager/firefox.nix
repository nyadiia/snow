{
  inputs,
  pkgs,
  config,
  ...
}:
{
  programs.firefox = {
    enable = true;
    #    package = pkgs.floorp;
    #    profiles."default" = {
    #      isDefault = true;
    #
    #      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    #        ublock-origin
    #        clearurls
    #        bitwarden
    #      ];
    #
    #      search = {
    #        default = "DuckDuckGo";
    #        engines = {
    #          "Nix Packages" = {
    #            urls = [
    #              {
    #                template = "https://search.nixos.org/packages";
    #                params = [
    #                  {
    #                    name = "type";
    #                    value = "packages";
    #                  }
    #                  {
    #                    name = "query";
    #                    value = "{searchTerms}";
    #                  }
    #                ];
    #              }
    #            ];
    #
    #            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #            definedAliases = [ "@np" ];
    #          };
    #
    #          "Nix Options" = {
    #            urls = [
    #              {
    #                template = "https://search.nixos.org/options";
    #                params = [
    #                  {
    #                    name = "type";
    #                    value = "packages";
    #                  }
    #                  {
    #                    name = "query";
    #                    value = "{searchTerms}";
    #                  }
    #                ];
    #              }
    #            ];
    #
    #            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #            definedAliases = [ "@no" ];
    #          };
    #
    #          "NixOS Wiki" = {
    #            urls = [ { template = "https://nixos.wiki/index.php?search=%s{searchTerms}"; } ];
    #            iconUpdateURL = "https://nixos.wiki/favicon.png";
    #            updateInterval = 24 * 60 * 60 * 1000; # every day
    #            definedAliases = [ "@nw" ];
    #          };
    #        };
    #      };
    #
    #      userChrome = ''
    #        /* Remove close button*/ 
    #        .titlebar-buttonbox-container { 
    #          display:none
    #        };
    #        #titlebar {
    #          background-color: #${config.lib.stylix.colors.base01} !important;
    #        };  
    #      '';
    #    };
  };
}
