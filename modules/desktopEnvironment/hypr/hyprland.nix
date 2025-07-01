{ inputs, config, pkgs, lib, settings, ... }:
let

  defaultTerminal = terminalOptions:
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

in {

  environment.systemPackages = with pkgs; [
    # hyprcursor

    qt5.qtwayland
    libsForQt5.qt5ct
    libsForQt5.qt5.qtimageformats

    qt6.qtwayland

    rofi-wayland

    gnome-icon-theme
    kdePackages.breeze-icons

    wofi

    grim
    slurp

    # swaync
    libnotify

    libsForQt5.dolphin
    nemo
    # xwaylandvideobridge

    sox # for playing a notification sound

    inputs.hyprpolkitagent.packages."${pkgs.system}".hyprpolkitagent
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  xdg = {
    portal = {
      enable = true;
      # xdgOpenUsePortal = true;
      # config = { hyprland.default = [ "hyprland" ]; };

      extraPortals = [
        inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ]; # for all desktops
        hyprland.default = [ "gtk" "hyprland" ]; # specifically for Hyprland sessions
        hyprland."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };

    terminal-exec = {
      enable = true;
      package = pkgs.xdg-terminal-exec;
      settings.default = defaultTerminal settings.customization.terminal;
    };

    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = lib.mkForce [ "org.kde.dolphin.deskop" ];
        # "x-scheme-handler/http" = [ "${browser}" ];
        # "x-scheme-handler/https" = [ "${browser}" ];
      };
      addedAssociations = {
        "inode/directory" = lib.mkForce [ "org.kde.dolphin.deskop" ];
        # "x-scheme-handler/http" = [ "${browser}" ];
        # "x-scheme-handler/https" = [ "${browser}" ];
      };
      removedAssociations = {
        "inode/directory" = lib.mkForce [ "kitty-open.deskop" ];
      };
    };
  };

  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://wezterm.cachix.org"
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
