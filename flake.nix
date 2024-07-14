{
  description = "crem's nix :)";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix
    stylix.url = "github:danth/stylix";

    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # Firefox Addons
    firefox-addons = {
	    url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
	    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    catppuccin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
    ];
  in {
    # Custom Packags and modfications as overlays
    overlays = import ./overlays {inherit inputs;};
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      kuma = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [ 
          stylix.nixosModules.stylix 
          ./hosts/kuma/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.crem = import ./hosts/kuma/home.nix;
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
			}
		];
      };
      shanks = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [ 
          stylix.nixosModules.stylix 
          ./hosts/shanks/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.crem = import ./hosts/shanks/home.nix;
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
          }
        ];
      };
    };
  };
}
