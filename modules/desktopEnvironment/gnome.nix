{ pkgs, ... }:
{
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.gnome.excludePackages =  with pkgs; [
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
}
