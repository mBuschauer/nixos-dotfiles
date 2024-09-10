{ pkgs, ... }:
{
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.gnome.excludePackages =  with pkgs; [
    gnome-terminal
    gnome.gnome-software
    gnome.gnome-music
    # gnome-photos
    simple-scan
    totem
    epiphany
    geary
  ];
}
