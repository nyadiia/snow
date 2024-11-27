{
  description = "nyadiia's systems configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";

    # it's funny
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # de
    hyprland.url = "github:hyprwm/hyprland";

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

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/Matugen";

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
      stylix,
      nixvim,
      systems,
      ...
    }:

    let
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        inputs.nix-matlab.overlay
        inputs.lix-module.overlays.default
      ];
      pkgs = import nixpkgs { inherit overlays system config; };
      small = import nixpkgs-small { inherit system config; };
      style = import ./modules/matugen.nix { inherit pkgs small inputs; };

      specialArgs = {
        inherit
          inputs
          self
          pkgs
          hyprland
          small
          style
          ;
      };

      eachSystem =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {

      packages = eachSystem (pkgs: {
        nvim = nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
          inherit pkgs;
          module = import ./packages/nixvim;
        };
      });

      nixosConfigurations = {
        hyprdash = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            inputs.lix-module.nixosModules.default
            ./hosts/hyprdash
            nix-index-database.nixosModules.nix-index
            nixos-hardware.nixosModules.framework-11th-gen-intel
            {
              hardware.framework.laptop13.audioEnhancement = {
                enable = true;
                rawDeviceName = "alsa_output.pci-0000_00_1f.3.analog-stereo";
              };
            }
            stylix.nixosModules.stylix
            ./modules/stylix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nyadiia.imports = [
                  {
                    home.packages = [ inputs.zen.packages.x86_64-linux.specific ];
                  }
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
      };
    };
}
