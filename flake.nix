{
  description = "nyadiia's systems configuration";
  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware goofyness
    # add your model from this list: 
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };
  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }: {
    overlays = {
      # Inject 'unstable' into the overridden package set, so that
      # the following overlays may access them (along with any system configs
      # that wish to do so).
      pkg-sets = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; };
        }
      );
    };
    nixosConfigurations= {
      hyprdash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          .hosts/system.nix
          .hosts/hyprdash
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyadiia = import ./home-manager;
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
