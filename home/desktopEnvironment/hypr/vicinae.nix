{ pkgs, config, inputs, ... }: {
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
      (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
        inherit pkgs;
        pname = "nix";
        src = pkgs.fetchFromGitHub { # You can also specify different sources other than github
          owner = "vicinaehq";
          repo = "extensions";
          rev = "610459553a20cf510fa414844f0d094f14ae9643"; # If the extension has no releases use the latest commit hash
          sha256 = "sha256-z4SqRFhJzAlBhNzgX7wHNZtEDnu5PIypYkBWOJtjyuA=";
        } + "/extensions/nix"; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
      })
    ];
  };

}
