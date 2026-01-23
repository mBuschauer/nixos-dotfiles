{ pkgs, config, inputs, ... }:
let

  mkVicinaeExtension = inputs.vicinae.packages.${pkgs.system}.mkVicinaeExtension;
in {
  services.vicinae = {
    enable = true;
    autoStart = true;
    # pacakge = inputs.vicinae.packages."${pkgs.system}".default;
    settings = {
      faviconService = "twenty"; # twenty | google | none
      font.size = 11;
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      theme.name = "catppuccin-mocha";
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };
    # Installing (vicinae) extensions declaratively
    extensions = [
      (mkVicinaeExtension {
        pname = "nix";
        src = pkgs.fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "610459553a20cf510fa414844f0d094f14ae9643";
          sha256 = "sha256-z4SqRFhJzAlBhNzgX7wHNZtEDnu5PIypYkBWOJtjyuA=";
        }
          + "/extensions/nix"; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
      })
      # (mkVicinaeExtension {
      #   pname = "pokedex";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "raycast";
      #     repo = "extensions";
      #     rev = "b8c8fcd7ebd441a5452b396923f2a40e879565ba";
      #     sha256 = "sha256-z4SqRFhJzAlBhNzgX7wHNZtEDnu5PIypYkBWOJtjyuA=";
      #   }
      #     + "/extensions/pokedex"; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
      # })
    ];
  };

}
