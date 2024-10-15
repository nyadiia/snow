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

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # de
    hyprland.url = "github:hyprwm/hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other programs
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nadiavim = {
      url = "github:nyadiia/nadiavim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      nixvim,
      ...
    }:

    let
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        inputs.nix-matlab.overlay
        # (final: prev: { neovim = inputs.nadiavim.packages.${system}.default; })
        (final: prev: {
          kitty = prev.kitty.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              ./patches/allow_bitmap_fonts.patch
            ];
          });
        })
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

      nixvim' = nixvim.legacyPackages.x86_64-linux;
    in
    {
      packages.x86_64-linux = {
        nvim = nixvim'.makeNixvim (import ./packages/nixvim);
      };
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
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
                  inputs.nixvim.homeManagerModules.nixvim
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.ironbar.homeManagerModules.default
                ];
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };
        # crystal-heart = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs pkgs;
        #   };
        #   modules = [
        #     ./hosts/crystal-heart
        #     nix-index-database.nixosModules.nix-index
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager = {
        #         useGlobalPkgs = true;
        #         useUserPackages = true;
        #         users.nyadiia.imports = [ ./home-manager/server.nix ];
        #         extraSpecialArgs = {
        #           inherit inputs;
        #         };
        #       };
        #     }
        #   ];
        # };
      };
    };
}
