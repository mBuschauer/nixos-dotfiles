{ pkgs, ... }:
let
  config =
    rec {
      system = "x86_64-linux";
      hostname = "MarcoMNix"; # Hostname
      username = "marco"; # Username
      gpu = "nvidia"; # supported: {nvidia, amd}
      desktopEnvironment = [
        # does nothing atp
        "hyprland"
      ];

      # TODO: Make this set the default terminal, maybe first option is set as default
      terminal = [ "wezterm" ]; # only supported `wezterm` and `kitty`. There is no error handling if this is left empty. DO NOT LEAVE EMPTY
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
  };
  

  # this doesnt work, not sure why
  assertions = [
    (
      assert config.system == "x86_64-linux";
      "Invalid system type. Supported: 'x86_64-linux'."
    )
  ];
}

