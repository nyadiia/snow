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

    # anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # ironbar
    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, anyrun, ironbar, ... }: 

  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
    
  in {
    nixosConfigurations = {
      hyprdash = nixpkgs.lib.nixosSystem {
        #inherit system;
        specialArgs = {
          inherit inputs unstable;
        };
	system.packages = [ anyrun.packages.${system}.anyrun ];
        modules = [
          ./hosts/hyprdash
	 # ./modules/gnome.nix
	  ./modules/hyprland.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyadiia = import ./home-manager/laptop.nix;
            home-manager.extraSpecialArgs = { inherit inputs unstable; };
	    home-manager.sharedModules = [
	      inputs.ironbar.homeManagerModules.default
	    ];
          }
        ];
      };
    };
  };
}
