{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-azuki.url = "github:nyadiia/nixpkgs/azuki";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-index
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wayland bar
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

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
    inputs@{
      nixpkgs,
      nixpkgs-small,
      nixpkgs-azuki,
      home-manager,
      nixos-hardware,
      nix-index-database,
      ironbar,
      stylix,
      ...
    }:
    let
      overlays = [ inputs.nix-matlab.overlay ];
      username = "nyadiia";
      email = "nyadiia@pm.me";
      signingKey = "9330C73893C84271F2EC";
      flake = "/home/nyadiia/snow";

      config.allowUnfree = true;
    in
    {
      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            pkgs-azuki = import nixpkgs-azuki { inherit system config; };
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
            {
              home-manager.users.${username}.imports = [
                ./hm-modules/shell
                ./hm-modules/gtk.nix
                ./hm-modules/mako.nix
                ./hm-modules/fcitx.nix
                ./hm-modules/alacritty.nix
                ./hm-modules/fuzzel.nix
                ./hm-modules/vscode.nix
                ./hm-modules/firefox.nix
                ./hm-modules/ironbar.nix
                ./hm-modules/hyprland.nix
                ironbar.homeManagerModules.default
              ];
            }
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./hosts/system.nix
            ./hosts/hyprdash/configuration.nix
            ./hosts/hyprdash/hardware-configuration.nix
            ./hosts/home.nix
            ./modules/stylix.nix
	    ./modules/suspend-then-hibernate.nix
          ];
        };
      };
    };
}
