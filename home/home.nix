{ inputs, pkgs, settings, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "${settings.userDetails.username}";
    homeDirectory = "/home/${settings.userDetails.username}";
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "vim";
      # TERM = "kitty";
      TERM = builtins.head settings.customization.terminal;
      BROWSER = "firefox";

      HISTTIMEFORMAT = "%d/%m/%y %T "; # for cmd-wrapped to work
      HISTFILE = "/home/${settings.userDetails.username}/.bash_history";
    };
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ ];
    historyFile = "/home/${settings.userDetails.username}/.bash_history";
    historyFileSize = 100000;
    historyIgnore = [
      "sl"
    ];
    historySize = 100000;

    bashrcExtra = ''
      shopt -s histappend  # Append to the history file
      PROMPT_COMMAND="history -a; history -n; history -r; $PROMPT_COMMAND"
    '';


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
    pictures = "/home/${settings.userDetails.username}/Pictures";
    download = "/home/${settings.userDetails.username}/Downloads";
    documents = "/home/${settings.userDetails.username}/Documents";
    desktop = "/home/${settings.userDetails.username}/Desktop";
  };
}
