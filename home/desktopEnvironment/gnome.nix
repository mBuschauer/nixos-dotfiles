{ pkgs, ... }:
{
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

}
