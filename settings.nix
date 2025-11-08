{ pkgs, ... }:
let
  config = rec {
    system = "x86_64-linux";
    hostname = "MarcoMNix"; # Hostname
    username = "marco"; # Username
    gpu = "nvidia"; # supported: {nvidia, amd}
    state_version = "24.11";
    desktopEnvironment = [
      "hyprland"
      # "cosmic" # doesnt work
      # "gnome"
      # "kde"
      # "cinnamon"
    ];
    # TODO: Make work with waybar
    monitors = [
      "HDMI-A-1, preferred, 1920x0, 1"
      "DP-1, preferred, 0x0, 1"
      # "DP-3, preferred, 1920x0, 1"
      # "DP-2, preferred, 0x0, 1"
    ];
    terminal = [
      # "kitty"
      "wezterm"
      # "ghostty"  
    ]; # only supported `wezterm` and `kitty` (and `ghostty`). There is no error handling if this is filled with wrong information.
    printers = false;
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
    cups_enabled = config.printers;
  };

}