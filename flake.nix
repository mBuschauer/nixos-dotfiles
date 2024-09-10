{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    hyprland = {
	    type = "git";
	    url = "https://github.com/hyprwm/Hyprland";
	    submodules = true;
	  };

    waybar = {
	    type = "git";
	    url = "https://github.com/Alexays/Waybar";
	  };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tsui = {
      # url = "github:neuralinkcorp/tsui";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };

};

  outputs = { 
      nixpkgs, 
      nixpkgs-stable, 
      home-manager, 
      ... 
    } @ 
    inputs: 
    let
		  system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
		    specialArgs = { inherit inputs; };

		    modules = [
          ({config, pkgs, ...}: 
            {
              nixpkgs.overlays = [ overlay-stable ];
            }
          )
			    ./configuration.nix
          inputs.home-manager.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco.imports = [ ./home/default.nix ];
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.backupFileExtension = "backupExt";
          }
	      ];
	    };
    };


}
