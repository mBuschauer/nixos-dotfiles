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
      restart-network = "sudo systemctl restart NetworkManager.service";
      nmcli-fzf = ''
        set -euo pipefail

        # 1) Grab the full selected line (BSSID + everything else)
        selected=$(nmcli --color yes \
            -f 'bssid,in-use,signal,bars,freq,rate,security,ssid' \
            device wifi list --rescan yes \
          | fzf --ansi \
                --with-nth=2.. \
                --reverse \
                --cycle \
                --header-lines=1 \
                --margin='1,2,1,2' \
                --color='16,gutter:-1' \
                --header='Select Wi-Fi network:' \
        )

        # 2) If nothing was chosen, exit
        if [[ -z "$selected" ]]; then
          echo "No network selected. Exiting."
          exit 1
        fi

        # 3) Extract BSSID and SSID separately
        #    Field 1 is the BSSID (MAC)
        bssid=$(awk '{print $1}' <<< "$selected")

        # Remove cols 1-7, then trim leading spaces to get the SSID
        ssid=$(awk '{
            $1=$2=$3=$4=$5=$6=$7="";
            sub(/^[[:space:]]+/, "");
            print
          }' <<< "$selected")

        # 4) Try to connect by BSSID (silent), falling back to --ask on failure
        echo "Please wait while connecting to \"$ssid\"…"
        if nmcli device wifi connect "$bssid" &>/dev/null; then
          echo "Connected to “$ssid”."
        else
          echo "Silent connect failed; prompting for credentials…"
          if nmcli -a device wifi connect "$bssid"; then
            echo "Connected to “$ssid”."
          else
            echo "Failed to connect to “$ssid”."
            printf "\nPress any key to close.\n" && read -n1 -r
            exit 1
          fi
        fi
        # 5) Pause so you can see any messages
        printf "\nPress any key to close.\n" && read -n1 -r
      '';
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
