{ inputs, pkgs, lib, ... }: {

  programs.anyrun = {
    enable = true;
    package = inputs.anyrun.packages.${pkgs.system}.anyrun;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        dictionary
        stdin
        translate
        websearch
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.35; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;
      keybinds = [
        {
          key = "Escape";
          action = "close";
        }
        {
          key = "Return";
          action = "select";
        }
        {
          key = "Up";
          action = "up";
        }
        {
          key = "Down";
          action = "down";
        }
      ];
    };

    extraCss = builtins.readFile (./. + "/style-dark.css");

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 8,
          terminal: Some(Terminal(
            command: "wezterm",
            args: "-e {}",
          )),
        )
      '';
      "shell.ron".text = ''
        Config(
          prefix: ">"
        )
      '';
      "dictionary.ron".text = ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';
      "translate.ron".text = ''
        Config(
          prefix: ":",
          language_delimiter: ">",
          max_entries: 3,
        )
      '';
      "websearch.ron".text = ''
        Config(
          prefix: "?",
          // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
          //
          // Custom engines can be defined as such:
          // Custom(
          //   name: "Searx",
          //   url: "searx.be/?q={}",
          // )
          engines: [Google],
        )
      '';
    };
  };
}
