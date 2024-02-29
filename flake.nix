{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware goofyness
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #    # matlab
    #    nix-matlab = {
    #      # Recommended if you also override the default nixpkgs flake, common among
    #      # nixos-unstable users:
    #      inputs.nixpkgs.follows = "nixpkgs";
    #      url = "gitlab:doronbehar/nix-matlab";
    #    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
      #    flake-overlays = [
      #      inputs.nix-matlab.overlay
      #    ];

    in
    {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstable;
          };
          modules = [
            ./hosts/hyprdash
            ./modules/hyprland.nix
            inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia = import ./home-manager/laptop.nix;
              home-manager.extraSpecialArgs = { inherit inputs unstable; };
            }
          ];
        };
        wavedash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstable;
          };
          modules = [
            ./hosts/wavedash
            ./modules/hyprland.nix
            # inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nyadiia = import ./home-manager/desktop.nix;
              home-manager.extraSpecialArgs = { inherit inputs unstable; };
            }
          ];
        };
      };
    };
}
