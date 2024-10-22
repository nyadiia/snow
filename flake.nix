{
  description = "nyadiia's systems configuration";

  inputs = {

    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my neovim flake
    nadiavim = {
      url = "github:nyadiia/nadiavim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # matlab
    nix-matlab = {
      # Recommended if you also override the default nixpkgs flake, common among
      # nixos-unstable users:
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/nyadiia.keys";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-small,
      home-manager,
      nixos-hardware,
      nix-index-database,
      hyprland,
      hyprpaper,
      stylix,
      ...
    }:
    let
      config.allowUnfree = true;
      overlays = [ inputs.nix-matlab.overlay ];

      username = "nyadiia";
      email = "nyadiia@pm.me";
      signingKey = "9330C73893C84271F2EC";
      flake = "/home/nyadiia/snow";

      mkSystem =
        {
          system ? "x86_64-linux",
          name,
          hardware,
          modules ? [ ],
          hm-modules ? [ ],
        }:
        let
          pkgs = import nixpkgs { inherit system config overlays; };
          pkgs-small = import nixpkgs-small { inherit system config overlays; };
          # style = import ./style/default.nix { inherit pkgs; };
          nixosConfig = ./. + "/hosts/${name}";
          hmConfig = ./. + "/hm/${name}.nix";
          specialArgs = {
            inherit
              inputs
              stylix
              pkgs
              pkgs-small
              hyprland
              hyprpaper
              username
              email
              signingKey
              flake
              ;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./modules/system.nix
            ./modules/stylix.nix
            nixosConfig
            hardware
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username}.imports = [
                  hmConfig
                  nix-index-database.hmModules.nix-index
                ] ++ hm-modules;
                extraSpecialArgs = specialArgs;
              };
            }
          ] ++ modules;
        };

    in
    {
      nixosConfigurations = {
        hyprdash = mkSystem {
          name = "hyprdash";
          hardware = nixos-hardware.nixosModules.framework-11th-gen-intel;
          hm-modules = [
            inputs.ironbar.homeManagerModules.default
          ];
        };
        # hyprdash = nixpkgs.lib.nixosSystem rec {
        #   system = "x86_64-linux";
        #   specialArgs = {
        #     inherit inputs username;
        #   };
        #   modules = [
        #     {
        #       home-manager.users.${username}.imports = [
        #         ./hm-modules/shell
        #         ./hm-modules/gtk.nix
        #         ./hm-modules/mako.nix
        #         ./hm-modules/fcitx.nix
        #         ./hm-modules/alacritty.nix
        #         ./hm-modules/fuzzel.nix
        #         ./hm-modules/vscode.nix
        #         ./hm-modules/firefox.nix
        #         ./hm-modules/ironbar.nix
        #         ./hm-modules/hyprland.nix
        #         ironbar.homeManagerModules.default
        #       ];
        #     }
        #     nix-index-database.nixosModules.nix-index
        #     nixos-hardware.nixosModules.framework-11th-gen-intel
        #     home-manager.nixosModules.home-manager
        #     stylix.nixosModules.stylix
        #     ./hosts/system.nix
        #     ./hosts/hyprdash/configuration.nix
        #     ./hosts/hyprdash/hardware-configuration.nix
        #     ./hosts/home.nix
        #     ./modules/stylix.nix
        #     ./modules/suspend-then-hibernate.nix
        #   ];
        # };
      };
    };
}
