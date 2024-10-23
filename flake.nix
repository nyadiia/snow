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

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other programs
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/nyadiia.keys";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-small,
      nixos-hardware,
      hyprland,
      flake-utils,
      nixvim,
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
          small = import nixpkgs-small { inherit system config overlays; };
          # style = import ./style/default.nix { inherit pkgs; };
          nixosConfig = ./. + "/hosts/${name}";
          hmConfig = ./. + "/hm/${name}.nix";
          specialArgs = {
            inherit
              inputs
              pkgs
              small
              hyprland
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
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username}.imports = [
                  hmConfig
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.nixvim.homeManagerModules.nixvim
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
          modules = [
            inputs.stylix.nixosModules.stylix
            ./modules/stylix.nix
          ];
          hm-modules = [
            inputs.ironbar.homeManagerModules.default
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        nixvimPkgs = nixvim.legacyPackages."${system}";
        nixvimLib = nixvim.lib."${system}";
        nvim = nixvimPkgs.makeNixvimWithModule {
          inherit pkgs;
          module = import ./packages/nixvim;
        };
      in
      {
        checks = {
          nvim = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "nadiavim configuration";
          };
        };
        packages = {
          inherit nvim;
        };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
