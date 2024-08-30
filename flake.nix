{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    azuki.url = "github:nyadiia/nixpkgs/azuki";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

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

    zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = { };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-small,
      nixpkgs-stable,
      home-manager,
      nixos-hardware,
      nix-index-database,
      hyprland,
      stylix,
      azuki,
      ...
    }:

    let
      username = "nyadiia";
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
      stable = import nixpkgs-stable { inherit system config; };
      azuki-pkgs = import azuki { inherit system config; };
    in
    {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              pkgs
              hyprland
              small
              stable
              azuki-pkgs
              ;
          };
          modules = [
            { environment.systemPackages = [ inputs.zen-browser.packages."${system}".specific ]; }
            ./hosts/hyprdash
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            stylix.nixosModules.stylix
            ./hosts/stylix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia.imports = [
                ./home-manager/laptop.nix
                # inputs.nixvim.homeManagerModules.nixvim
                inputs.nix-index-database.hmModules.nix-index
                inputs.ironbar.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  stable
                  hyprland
                  small
                  azuki-pkgs
                  ;
              };
            }
          ];
        };
        crystal-heart = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs stable;
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
                inherit inputs stable;
              };
            }
          ];
        };
        # wavedash = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs unstable;
        #   };
        #   modules = [
        #     ./hosts/wavedash
        #     nix-index-database.nixosModules.nix-index
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.useGlobalPkgs = true;
        #       home-manager.useUserPackages = true;
        #       home-manager.users.nyadiia = import ./home-manager/desktop.nix;
        #       home-manager.extraSpecialArgs = { inherit inputs unstable; };
        #     }
        #   ];
        # };
        # demodash = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs unstable;
        #   };
        #   modules = [
        #     ./hosts/demodash
        #     nix-index-database.nixosModules.nix-index
        #     nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
        #     nixos-hardware.nixosModules.common-gpu-amd
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.useGlobalPkgs = true;
        #       home-manager.useUserPackages = true;
        #       home-manager.users.nyadiia = import ./home-manager/server.nix;
        #       home-manager.extraSpecialArgs = { inherit inputs unstable; };
        #     }
        #   ];
        # };
        # farewell = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs unstable;
        #   };
        #   modules = [
        #     ./hosts/farewell
        #     nix-index-database.nixosModules.nix-index
        #     nixos-hardware.nixosModules.common-cpu-intel
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.useGlobalPkgs = true;
        #       home-manager.useUserPackages = true;
        #       home-manager.users.nyadiia = import ./home-manager/server.nix;
        #       home-manager.extraSpecialArgs = { inherit inputs unstable; };
        #     }
        #   ];
        # };
      };

      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        # pass inputs as specialArgs
        extraSpecialArgs = {
          inherit inputs pkgs stable;
        };

        # import your home.nix
        modules = [ ./home-manager/laptop.nix ];
      };
    };
}
