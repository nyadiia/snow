{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware goofyness
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nix-index-database,
      ironbar,
      ...
    }@inputs:

    let
      flake-overlays = [ inputs.nix-matlab.overlay ];
      username = "nyadiia";
      email = "nyadiia@pm.me";
      signingKey = "C8DC17070AC33338193F9723229718FDC160E880";
      flake = "/home/nyadiia/snow";
    in
    {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              flake-overlays
              username
              email
              signingKey
	      flake
              ;
          };
          modules = [
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            ./hosts/system.nix
            ./hosts/hyprdash/configuration.nix
            {
              home-manager.users.${username}.imports = [
                ./hm-modules/shell
                ./hm-modules/gtk.nix
                ./hm-modules/mako.nix
                ./hm-modules/fcitx.nix
                ./hm-modules/kitty.nix
                ./hm-modules/fuzzel.nix
                ./hm-modules/vscode.nix
                ./hm-modules/firefox.nix
                ./hm-modules/ironbar.nix
                ./hm-modules/hyprland.nix
                ironbar.homeManagerModules.default
              ];
            }
            ./hosts/hyprdash/hardware-configuration.nix
            ./hosts/home.nix
            # /etc/nixos/hardware-configuration.nix
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
