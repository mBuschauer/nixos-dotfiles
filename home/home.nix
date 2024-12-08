{ inputs, pkgs, settings, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.05";
    sessionVariables = {
      # EDITOR = "lvim";
      TERM = "kitty";
      BROWSER = "firefox";

      HISTTIMEFORMAT = "%d/%m/%y %T "; # for cmd-wrapped to work
      HISTFILE = "~/.bash_history";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      # vim = "lvim";
      top = "btm";
      # cat = "bat";
      disk-analysis = "sudo ncdu / --exclude=/mnt";
      # edit-config = "cd /etc/nixos/ && sudo lvim"; 
      update-config = "sudo nixos-rebuild switch";
      upgrade-config = ''
        (
          original_dir=$(pwd)
          trap "cd $original_dir" EXIT INT TERM HUP

          cd /etc/nixos || exit 1
          sudo nix flake update
          sudo nixos-rebuild switch
        )
      '';
      neofetch = "fastfetch";
      mpd-cli = "ncmpcpp";
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
