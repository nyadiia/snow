{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware goofyness
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # nix-index
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # matlab
    nix-matlab = {
      # Recommended if you also override the default nixpkgs flake, common among
      # nixos-unstable users:
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    ssh-keys = {
      url = "https://github.com/nyadiia.keys";
      flake = false;
    };
  };


  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, nix-index-database, ... }:

    let
      flake-overlays = [
        inputs.nix-matlab.overlay
      ];
      flake-keys = inputs.ssh-keys.outPath;
    in {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          # specialArgs = {
          #   inherit inputs unstable flake-overlays;
          # };
          modules = [
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            ./hosts/system.nix
            ./hosts/home.nix
            ./hosts/hyprdash/hardware-configuration.nix
            # /etc/nixos/hardware-configuration.nix
            {
              nixpkgs.overlays = [
                (self: super: {
                  blas = super.blas.override {
                    blasProvider = self.mkl;
                  };

                  lapack = super.lapack.override {
                    lapackProvider = self.mkl;
                  };
                })
              ] ++ flake-overlays;

              networking.hostName = "hyprdash";
              custom = {
                user = {
                  name = "nyadiia";
                  ssh-keys = [ flake-keys ];
                };
                podman.enable = true;
                nix-index.enable = true;
                syncthing.enable = true;
                laptop = true;
              };

              hm.imports = [
                ./hm-modules/gtk.nix
                ./hm-modules/mako.nix
                ./hm-modules/kitty.nix
                ./hm-modules/fuzzel.nix
                ./hm-modules/vscode.nix
                ./hm-modules/firefox.nix
                ./hm-modules/ironbar.nix
                ./hm-modules/hyprland.nix
                ./hm-modules/shell
              ];
            }
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.nyadiia.imports = [
            #     ./home-manager/laptop.nix
            #     inputs.nixvim.homeManagerModules.nixvim
            #     inputs.nix-index-database.hmModules.nix-index
            #     inputs.ironbar.homeManagerModules.default
            #   ];
            #   home-manager.extraSpecialArgs = { inherit inputs unstable; };
            # }
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
    };
}
