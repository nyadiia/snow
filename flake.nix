{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    # hyprpaper.inputs.nixpkgs.follows = "hyprland";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

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

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = { };

  outputs =
    inputs@{
      self,
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
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.nix-matlab.overlay
        (final: prev: { neovim = inputs.nadiavim.packages.${system}.default; })
      ];
      pkgs = import nixpkgs { inherit overlays system config; };
      small = import nixpkgs-small { inherit system config; };

      eachSystem =
        function:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ] (system: function (import nixpkgs { inherit config system; }));

    in
    {
      packages = eachSystem (pkgs: {
        azuki = pkgs.callPackage ./packages/azuki.nix { };
      });
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              self
              pkgs
              hyprland
              hyprpaper
              small
              ;
          };
          modules = [
            ./hosts/hyprdash
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            stylix.nixosModules.stylix
            ./modules/stylix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nyadiia.imports = [
                  ./home-manager/laptop.nix
                  # inputs.nixvim.homeManagerModules.nixvim
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.ironbar.homeManagerModules.default
                ];
                extraSpecialArgs = {
                  inherit
                    inputs
                    self
                    hyprpaper
                    hyprland
                    small
                    ;
                };
              };
            }
          ];
        };
        crystal-heart = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs;
          };
          modules = [
            ./hosts/crystal-heart
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia.imports = [ ./home-manager/server.nix ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
      };
    };
}
