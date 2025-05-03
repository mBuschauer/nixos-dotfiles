{ inputs, pkgs, settings, lib, ... }:
let
  matchFirstElement = list:
    if builtins.length list == 0 then
      throw "No default terminal selected in home.nix."
    else
      let first = builtins.elemAt list 0; in
      if first == "wezterm" then "wezterm"
      else if first == "ghostty" then "ghostty"
      else if first == "kitty" then "kitty"
      else throw "Error: unexpected value in the list";
in
{
  programs.home-manager.enable = true;
  home = {
    username = "${settings.userDetails.username}";
    homeDirectory = "/home/${settings.userDetails.username}";
    stateVersion = settings.userDetails.state_version;
    sessionVariables = {
      EDITOR = "lvim";
      # TERM = "kitty";
      TERM = matchFirstElement settings.customization.terminal;
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
      ls = lib.mkForce "lsd";
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
