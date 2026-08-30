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
      {
        output = "DP-2";
        mode = "preferred";
        position = "0x0";
        scale = 1;
      }
    ];
    terminal = [
      "wezterm"
      # "ghostty"
    ]; # only supported `wezterm` and `kitty` (and `ghostty`). There is no error handling if this is left empty. DO NOT LEAVE EMPTY
    printers = true;
    enableSecureboot = true;
  };

in
{
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
    enable_secureboot = config.enableSecureboot;
  };

}
