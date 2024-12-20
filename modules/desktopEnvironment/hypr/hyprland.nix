{ inputs, config, pkgs, lib, ... }:
{
  programs = {
    hyprland = {
      enable = false;
      xwayland.enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };

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
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        hyprland.default = [ "hyprland" ];
      };

      extraPortals = [
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    terminal-exec = {
      enable = true;
      package = pkgs.xdg-terminal-exec;
      settings = {
        default = [
          "wezterm.desktop"
        ];
      };
    };
    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = lib.mkForce [ "org.kde.dolphin.deskop" ];
      };
      addedAssociations = {
        "inode/directory" = lib.mkForce [ "org.kde.dolphin.deskop" ];
      };
      removedAssociations = {
        "inode/directory" = lib.mkForce [ "kitty-open.deskop" ];
      };
    };
  };

  nix.settings = {
    substituters = [ "https://wezterm.cachix.org" ];
    trusted-public-keys = [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
  };

  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
