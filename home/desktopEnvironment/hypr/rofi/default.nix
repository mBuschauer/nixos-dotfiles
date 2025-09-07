{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "JetBrainsMono Nerd Font 12";
    location = "center";
    modes = [
      "drun"
      # "run"
      "filebrowser"
      # "window"
      "calc"
      "emoji"
    ];
    plugins = with pkgs; [
			(rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
      rofi-emoji
      # (rofi-emoji.override { rofi-unwrapped = rofi-wayland-unwrapped; })
		];
    terminal = "${pkgs.wezterm}/bin/wezterm";
    extraConfig = {
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
      sidebar-mode = true;
      
      show-icons = true;
      icon-theme = "Papirus";

      kb-mode-next = "Right";
      kb-mode-previous = "Left";
      kb-move-char-forward = "";
      kb-move-char-back = "";
    };
    theme = ./dotfiles/themes/catppuccin-transparent.rasi;
  };

  # xdg.configFile."rofi" = {
  #   source = ./dotfiles;
  #   recursive = true;
  # };
}