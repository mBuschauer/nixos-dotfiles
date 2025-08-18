{ pkgs, ... }: {
  programs.eww = {
    enable = true;
    package = pkgs.eww;
  };

  xdg.configFile."eww" = {
    source = ./dotfiles;
    recursive = true;
  };
}
