{ inputs, config, pkgs, ... }:
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
    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.deskop" ];
      };
      addedAssociations = {
        "inode/directory" = [ "org.kde.dolphin.deskop" ];
      };
      removedAssociations = {
        "inode/directory" = [ "kitty-open.deskop" ];
      };
    };
  };

  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
