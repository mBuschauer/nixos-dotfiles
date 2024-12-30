{ pkgs, ... }:
let
  config =
    rec {
      system = "x86_64-linux";
      hostname = "nixos"; # Hostname
      username = "marco"; # Username
      gpu = "amd"; # supported: {nvidia, amd}
      desktopEnvironment = [
        "hyprland"
        # "cosmic" # doesnt work
        # "gnome"
        # "kde"
      ];
      # TODO: Make work with waybar
      monitors = [
        # "HDMI-A-1, preferred, 1920x0, 1"
        # "DP-1, preferred, 0x0, 1"
        "DP-3, preferred, 1920x0, 1"
        "DP-2, preferred, 0x0, 1"
      ];
      terminal = [ 
        "wezterm" 
        # "ghostty"  
      ]; # only supported `wezterm` and `kitty` (and `ghostty`). There is no error handling if this is left empty. DO NOT LEAVE EMPTY
    };


in
{
  userDetails = {
    hostname = config.hostname;
    username = config.username;
  };
  customization = {
    gpu = config.gpu;
    desktopEnvironment = config.desktopEnvironment;
    terminal = config.terminal;
    monitors = config.monitors;
  };

  # TODO: Make this work
  assertions = [
    (
      assert config.system == "x86_64-linux";
      "Invalid system type. Supported: 'x86_64-linux'."
    )
    (
      # TODO: Make sure that this tests that at least one functioning DE is selected
      assert config.desktopEnvironment != [ ];
      "Empty list for desktopEvironment"
    )
    (
      # TODO: Make sure that this tests that at least one functioning terminal is selected
      assert config.terminal != [ ];
      "Empty list for terminal"
    )
  ];
}

