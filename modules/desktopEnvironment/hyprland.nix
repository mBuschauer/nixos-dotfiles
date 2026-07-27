{
  inputs,
  config,
  pkgs,
  lib,
  settings,
  ...
}:
let

  defaultTerminal =
    terminalOptions:
    if builtins.length terminalOptions < 0 then
      throw "No terminal selected"
    else if builtins.head terminalOptions == "wezterm" then
      [ "wezterm.desktop" ]
    else if builtins.head terminalOptions == "kitty" then
      [ "kitty.desktop" ]
    else if builtins.head terminalOptions == "ghostty" then
      [ "ghostty.desktop" ] # this is not set up properly yet / tested
    else
      [ ];

  browser = "firefox.desktop";

in
{

  environment.systemPackages = with pkgs; [
    # hyprcursor

    qt5.qtwayland
    kdePackages.qt6ct
    kdePackages.qtimageformats

    qt6.qtwayland

    # swaync
    libnotify

    # kdePackages.dolphin
    # stable.libsForQt5.dolphin
    # xwaylandvideobridge

    sox # for playing a notification sound

    xdg-desktop-portal-gtk
  ];

  programs.dconf.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        common = {
          default = "hyprland";
          filechooser = "gtk";
        };
      };
    };
    terminal-exec = {
      enable = true;
      package = pkgs.xdg-terminal-exec;
      settings.default = defaultTerminal settings.customization.terminal;
    };

  };

  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://wezterm.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };
  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home-manager.users."${settings.userDetails.username}".imports = [
    ./hypr-pixelparty
    # ./hypr-quickshell
  ];

}
