# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  settings,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules
  ];

  assertions = [
    {
      assertion = settings.userDetails.system == "x86_64-linux";
      message = "Invalid system type. Supported: 'x86_64-linux'.";
    }
    {
      assertion = settings.customization.desktopEnvironment != [ ];
      message = "Empty list for desktopEvironment";
    }
    {
      assertion = settings.customization.terminal != [ ];
      message = "Empty list for terminal";
    }
    {
      assertion = (
        builtins.elem "kitty" settings.customization.terminal
        || builtins.elem "wezterm" settings.customization.terminal
        || builtins.elem "ghostty" settings.customization.terminal
      );
      message = "No valid terminal emulator selected.";
    }
    {
      assertion = (settings.customization.gpu == "amd" || settings.customization.gpu == "nvidia");
      message = "Unsupported GPU selected, found '${settings.customization.gpu}'";
    }
    {
      assertion = builtins.all (
        m: builtins.isAttrs m && (m ? output) && m.output != ""
      ) settings.customization.monitors;
      message = "Each entry in customization.monitors must be an attrset with a non-empty 'output' (e.g. { output = \"DP-1\"; mode = \"preferred\"; position = \"0x0\"; scale = 1; }).";
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = settings.userDetails.state_version; # Did you read the comment?

}
