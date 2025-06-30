{ pkgs, ... }:
let
  config = rec {
    system = "x86_64-linux";
    hostname = "nixos"; # Hostname
    username = "marco"; # Username
    gpu = "amd"; # supported: {nvidia, amd}
    state_version = "24.05";
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

in {
  userDetails = {
    hostname = config.hostname;
    username = config.username;
    system = config.system;
    state_version = config.state_version;
  };
  customization = {
    gpu = config.gpu;
    desktopEnvironment = config.desktopEnvironment;
    terminal = config.terminal;
    monitors = config.monitors;
  };

}

