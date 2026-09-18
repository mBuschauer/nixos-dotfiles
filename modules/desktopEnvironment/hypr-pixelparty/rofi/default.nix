{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-next;
    settings = pkgs.lib.mkDefault {
      font = "JetBrainsMono Nerd Font 12";
      location = 0; # center
      terminal = "${pkgs.xdg-terminal-exec}/bin/xdg-terminal-exec --hold";
      modes = [
        "drun"
        # "run"
        # "filebrowser"
        # "window"
        "calc"
        # "emoji"
        # "clipboard:cliphist-rofi"
      ];

      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      scroll-method = 1;
      cycle = false;

      display-drun = " Apps";
      display-run = " Run";
      display-window = " Window";
      display-filebrowser = " Location";
      display-Network = " Network";
      display-calc = " Calculator";
      display-ssh = " SSH";
      display-emoji = "󰞅 Emojis";
      display-clipboard = " Clipboard";
      sidebar-mode = true;

      show-icons = true;
      icon-theme = "Papirus-Dark";
    };

    plugins = with pkgs; [
      rofi-calc
      # (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
      rofi-emoji
      # (rofi-emoji.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
    theme = ./dotfiles/themes/catppuccin-transparent.rasi;
  };
}
