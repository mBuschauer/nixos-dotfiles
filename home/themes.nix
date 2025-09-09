{ pkgs, inputs, settings, ... }:
let
  isKitty = terminalOptions:
    if builtins.elem "kitty" terminalOptions then true else false;

  isWezterm = terminalOptions:
    if builtins.elem "wezterm" terminalOptions then true else false;

  isGhostty = terminalOptions:
    if builtins.elem "ghostty" terminalOptions then true else false;

  variant = "mocha";
  accent = "mauve";
  kvantumThemePackage =
    pkgs.catppuccin-kvantum.override { inherit variant accent; };

in {
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
      # package = pkgs.andromeda-gtk-theme;
      # name = "Andromeda";
      package = pkgs.sweet;
      name = "Sweet-Dark";
    };
    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
    style.package = kvantumThemePackage;
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-${variant}-${accent}
    '';

    "Kvantum/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}.kvconfig".source =
      "${kvantumThemePackage}/share/Kvantum/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}.kvconfig";
    "Kvantum/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}.svg".source =
      "${kvantumThemePackage}/share/Kvantum/catppuccin-${variant}-${accent}/catppuccin-${variant}-${accent}.svg";
  };

  home.packages = with pkgs; [
    gtk3
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugins
    qt6Packages.qt6ct
    qt6.qtwayland
    qt5.qtwayland
  ];

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

  programs.ghostty = {
    enable = isGhostty settings.customization.terminal;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-size = 12;
      # keybind = [  ];
    };
  };
}

