{
  pkgs,
  inputs,
  settings,
  lib,
  config,
  ...
}:
let
  isKitty = terminalOptions: if builtins.elem "kitty" terminalOptions then true else false;

  isWezterm = terminalOptions: if builtins.elem "wezterm" terminalOptions then true else false;

  isGhostty = terminalOptions: if builtins.elem "ghostty" terminalOptions then true else false;

  variant = "mocha";
  accent = "mauve";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override { inherit variant accent; };

  catppuccin-papirus = pkgs.catppuccin-papirus-folders.override {
    flavor = variant;
    accent = accent;
  };

  capitalize = s: (lib.toUpper (lib.substring 0 1 s)) + (lib.substring 1 (lib.stringLength s) s);

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
      package = pkgs.sweet;
      name = "Sweet-Dark";
      # name = "Catppuccin-${capitalize variant}-Standard-${capitalize accent}-Dark";
      # package = pkgs.catppuccin-gtk.override {
      #   accents = [ accent ];
      #   size = "standard";
      #   variant = variant;
      # };
    };
    iconTheme = {
      # package = pkgs.candy-icons;
      # name = "candy-icons";
      name = "Papirus-Dark";
      package = catppuccin-papirus;
    };
    gtk4.theme = config.gtk.theme;
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     gtk-theme = "Catppuccin-${capitalize variant}-Standard-${capitalize accent}-Dark";
  #     color-scheme = "prefer-dark";
  #   };

  #   # For Gnome shell
  #   "org/gnome/shell/extensions/user-theme" = {
  #     name = "Catppuccin-${capitalize variant}-Standard-${capitalize accent}-Dark";
  #   };
  # };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
    style.package = kvantumThemePackage;
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = "Catppuccin-${capitalize variant}-${capitalize accent}";
    };

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

    kvantumThemePackage
    libsForQt5.qtstyleplugin-kvantum
    # papirus-folders
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
    # package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
