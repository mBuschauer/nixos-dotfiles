{ pkgs, ... }: {
  home.packages = with pkgs; [ nwg-dock-hyprland ];


  xdg.configFile."nwg-dock-hyprland" = {
    source = ./dotfiles;
    recursive = true;
  };
}
