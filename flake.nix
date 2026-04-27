{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      # submodules = true;
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      type = "git";
      url = "https://github.com/Alexays/Waybar";
      # url = "https://github.com/mBuschauer/Waybar";
    };

    # hyprpanel = {
    #   url = "github:Jas-SinghFSU/HyprPanel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsysteminfo = {
      url = "github:hyprwm/hyprsysteminfo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpwcenter = {
      url = "github:hyprwm/hyprpwcenter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # swww.url = "github:LGFae/swww";

    # anyrun = {
    #   url = "github:anyrun-org/anyrun/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvix = {
    #   # nixvim configuration
    #   url = "github:niksingh710/nvix/a11cdb4a6d5164c5e30614c7f31f4111ba1c5802";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    wezterm.url = "github:wez/wezterm?dir=nix";

    lazyvim.url = "github:pfassina/lazyvim-nix";

    # ghostty.url = "github:ghostty-org/ghostty";

    cbr2cbz = {
      url = "github:mBuschauer/cbr2cbz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # aagl = {
    #   # an-anime-game-launcher
    #   url = "github:ezKEa/aagl-gtk-on-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # winapps = {
    #   url = "github:winapps-org/winapps";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # tsui = {
    # url = "github:neuralinkcorp/tsui";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };

    # vicinae.url = "github:vicinaehq/vicinae";

  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      # , winapps
      # , aagl
      # , hyprpanel
      ... # ...
    }@inputs:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs;

      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      settings = import (./. + "/settings.nix") { inherit pkgs; };
      secrets = import (./. + "/secrets.nix") { inherit pkgs; };
    in
    {
      nixosConfigurations."${settings.userDetails.hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit settings;
          inherit secrets;
        };
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                overlay-stable
                inputs.nix-cachyos-kernel.overlays.default

                # (import ./overlays/ollama-cuda.nix)
                # (import ./overlays/jellyfin-qt6.nix)
                (import ./overlays/catppuccin-papirus-16x16.nix)
                # (import ./overlays/libldac-dec.nix)
              ];
            }
          )

          ./configuration.nix
          inputs.home-manager.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users."${settings.userDetails.username}".imports = [
                # ({ modulesPath, ... }: {
                #   # disable default home-manager anyrun module
                #   disabledModules = [ "${modulesPath}/programs/anyrun.nix" ];
                # })
                # inputs.anyrun.homeManagerModules.anyrun # enable flake home-manager module
                # inputs.vicinae.homeManagerModules.default # enable vicinae home-manager module
                inputs.tailray.homeManagerModules.default # enable tailray home-manager module
                inputs.lazyvim.homeManagerModules.default # enable lazyvim hm module
                ./home/default.nix
              ];

              extraSpecialArgs = {
                inherit inputs;
                inherit settings;
                inherit secrets;
              };
              backupFileExtension = "backupExt";
            };
          }

          # {
          #   # aagl
          #   imports = [ aagl.nixosModules.default ];
          #   nix.settings = aagl.nixConfig; # Set up Cachix
          # }
        ];
      };
    };

}
