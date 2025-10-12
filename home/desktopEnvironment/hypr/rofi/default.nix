{ pkgs, ... }:
let
  nixpkgs.overlays = [
    (self: super: { rofi = super.rofi.override { waylandSupport = true; }; })
    (self: super: { rofi-unwrapped = super.rofi-unwrapped.override { waylandSupport = true; }; })
  ];
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
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
      rofi-calc
      # (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
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
      # icon-theme = "Papirus";
      icon-theme = "candy-icons";

      # kb-mode-next = "Right";
      # kb-mode-previous = "Left";
      # kb-move-char-forward = "";
      # kb-move-char-back = "";
    };
    # theme = ./dotfiles/themes/catppuccin.rasi;
    theme = ./dotfiles/themes/catppuccin-transparent.rasi;
    # theme = ./dotfiles/themes/sidebar-v2.rasi;
  };
  home.packages = with pkgs; [ papirus-icon-theme candy-icons ];

  # xdg.configFile."rofi" = {
  #   source = ./dotfiles;
  #   recursive = true;
  # };
}
