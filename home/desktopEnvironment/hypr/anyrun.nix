{ inputs, pkgs, ... }:
{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        dictionary
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.4; };
      # width = { absolute = 0; };
      # height = { absolute = 0;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      # layer = "";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;
    };
    extraCss = builtins.readFile (./. + "/style-dark.css");
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 8,
          terminal: Some("kitty"),
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
    };
  };
}
