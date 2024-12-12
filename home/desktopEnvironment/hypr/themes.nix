{ pkgs, inputs, ... }:
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

  programs.kitty = {
    enable = false;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 11;
    themeFile = "ayu_mirage";
    settings = {
      open_url_with = "default";
    };
  };

  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {
          font = wezterm.font("Fira Code"),
          font_size = 11.0,
          color_scheme = "Ayu Mirage",
          hide_tab_bar_if_only_one_tab = true,
          enable_wayland = true,
      }
    '';
  };
}

