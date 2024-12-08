{
  description = "nyadiia's systems configuration";

  inputs = {
    # nix basics
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";

    # to be honest it's just because it's "lesbian nix" and that's funny
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other programs
    zen = {
      url = "github:ch4og/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:/InioX/Matugen";

    ssh-keys = {
      url = "https://github.com/nyadiia.keys";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-small,
      nixos-hardware,
      hyprland,
      nixvim,
      zen,
      flake-utils,
      ssh-keys,
      ...
    }:
    let
      config.allowUnfree = true;
      overlays = [
        inputs.nix-matlab.overlay
        inputs.lix.overlays.default
      ];

      username = "nyadiia";
      email = "nyadiia@pm.me";
      signingKey = "9330C73893C84271F2EC";
      flake = "/home/nyadiia/snow";

      mkSystem =
        {
          system ? "x86_64-linux",
          name,
          hardware ? nixos-hardware.nixosModules.common-pc,
          modules ? [ ],
          hm-modules ? [ ],
        }:
        let
          pkgs = import nixpkgs { inherit system config overlays; };
          small = import nixpkgs-small { inherit system config overlays; };
          style = import ./modules/matugen.nix { inherit pkgs inputs; };
          nixosConfig = ./. + "/hosts/${name}";
          hmConfig = ./. + "/hm/${name}.nix";
          specialArgs = {
            inherit
              inputs
              pkgs
              small
              style
              zen
              hyprland
              username
              email
              signingKey
              flake
              ssh-keys
              ;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            inputs.lix.nixosModules.default
            ./modules/system.nix
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
            inputs.matugen.nixosModules.default
            # ./modules/matugen.nix
            ./modules/hyprland.nix
            ./modules/yubikey.nix
          ];
          hm-modules = [
            inputs.ironbar.homeManagerModules.default
          ];
        };
        farewell = mkSystem {
          name = "farewell";
          modules = [
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-cpu-intel
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
