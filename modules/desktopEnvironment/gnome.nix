{ pkgs, ... }:
{
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-terminal
    gnome-software
    gnome-music
    gnome-maps
    # gnome-photos
    simple-scan
    totem
    epiphany
    geary
  ];

  home-manager.users."${settings.userDetails.username}" = {
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        color-scheme = "prefer-dark";
      };
    };
    home.packages = with pkgs.gnomeExtensions; [
      appindicator
      desktop-icons-ng-ding
    ];
  };
}
