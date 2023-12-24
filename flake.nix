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

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }: 

  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
    
  in {
    nixosConfigurations = {
      hyprdash = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit unstable inputs;
        };
        modules = [
          ./hosts/hyprdash
	  ./modules/gnome.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyadiia = import ./home-manager/laptop.nix;
            home-manager.extraSpecialArgs = { inherit inputs unstable; };
          }
        ];
      };
    };
  };
}
