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
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  xdg = {
    # portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    #   config = { hyprland.default = [ "hyprland" ]; };

    #   extraPortals = [
    #     inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    #     pkgs.xdg-desktop-portal-gtk
    #   ];
    # };

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
    substituters = [ "https://wezterm.cachix.org" ];
    trusted-public-keys =
      [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
  };

  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
