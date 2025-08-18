{ pkgs, inputs, settings, ... }:
let
  isKitty = terminalOptions:
    if builtins.elem "kitty" terminalOptions then true
    else false;

  isWezterm = terminalOptions:
    if builtins.elem "wezterm" terminalOptions then true
    else false;

  isGhostty = terminalOptions:
    if builtins.elem "ghostty" terminalOptions then [ inputs.ghostty.packages.x86_64-linux.default ]
    else [ ];

in
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.stable.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.andromeda-gtk-theme;
      name = "Andromeda";
    };
  };

  home.packages = with pkgs; [ 

  ] ++ isGhostty settings.customization.terminal;

  programs.kitty = {
    enable = isKitty settings.customization.terminal;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 11;
    themeFile = "ayu_mirage";
    settings = {
      cursor_trail = 3; 
      open_url_with = "default";
    };
  };

  programs.wezterm = {
    enable = isWezterm settings.customization.terminal;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    package = pkgs.wezterm;

    extraConfig = ''
      return {
          font = wezterm.font("Fira Code"),
          font_size = 11.0,
          color_scheme = "Ayu Mirage",
          hide_tab_bar_if_only_one_tab = true,
          check_for_updates = false,
      }
    '';
  };
}

