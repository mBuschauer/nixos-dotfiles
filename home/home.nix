{ inputs, pkgs, settings, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "lvim";
      TERM = "kitty";
      BROWSER = "firefox";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      vim = "lvim";
      top = "btm";
      # cat = "bat";
      disk-analysis = "sudo ncdu / --exclude=/mnt";
      # edit-config = "cd /etc/nixos/ && sudo lvim"; 
      update-config = "sudo nixos-rebuild switch";
      upgrade-config = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch";
      neofetch = "fastfetch";
      # pokemon-icat = "/home/marco/.config/.pokemon-icat/pokemon-icat";
      # start-wayvnc = "wayvnc 0.0.0.0 --gpu --performance --socket=5900 --render-cursor --max-fps=60 &&";
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    pictures = "/home/${settings.username}/Pictures";
    download = "/home/${settings.username}/Downloads";
    documents = "/home/${settings.username}/Documents";
    desktop = "/home/${settings.username}/Desktop";
  };
}
