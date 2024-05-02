{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";


    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware goofyness
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";


    # hyprland
    hyprland.url = "github:hyprwm/Hyprland/d20ee312108d0e7879011cfffa3a83d06e48d29e";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ironbar
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # matlab
    nix-matlab = {
      # Recommended if you also override the default nixpkgs flake, common among
      # nixos-unstable users:
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
  };

  nixConfig = { };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, nixos-hardware, nix-index-database, ... }:

    let
      username = "nyadiia";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      stable = import nixpkgs-stable {
        inherit system;
        config = {
          permittedInsecurePackages = [ "electron-25.9.0" ];
          allowUnfree = true;
        };
      };

      flake-overlays = [
        inputs.nix-matlab.overlay
      ];

    in
    {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs stable flake-overlays;
          };
          modules = [
            ./hosts/hyprdash
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia.imports = [
                ./home-manager/laptop.nix
                inputs.nixvim.homeManagerModules.nixvim
                inputs.nix-index-database.hmModules.nix-index
                inputs.ironbar.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = { inherit inputs stable; };
            }
          ];
        };
        crystal-heart = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs stable flake-overlays;
          };
          modules = [
            ./hosts/crystal-heart
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia.imports = [
                ./home-manager/server.nix
              ];
              home-manager.extraSpecialArgs = { inherit inputs stable; };
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
        extraSpecialArgs = { inherit inputs pkgs stable; };

        # import your home.nix
        modules = [ ./home-manager/laptop.nix ];
      };
    };
}
