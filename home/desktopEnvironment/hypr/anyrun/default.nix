{ inputs, pkgs, lib, ... }:
{
  programs.anyrun = {
    enable = lib.mkForce true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        dictionary
        stdin
        translate
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.35; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
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
          terminal: Some("wezterm"),
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
    };
  };
}
