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

  conflux = pkgs.stdenvNoCC.mkDerivation {
    pname = "conflux-icon-theme";
    version = "0-unstable-2026-09-13";

    src = pkgs.fetchFromGitHub {
      owner = "MoshiurRahmanAdib";
      repo = "Conflux-Icon-Theme";
      rev = "d64da34e6e81dd9a08ca068d55038b0578b1ba98";
      hash = "sha256-jmm+k7S1w02iEbUhviyKViBxbdJFnusvSKVA6hA1l0A=";
    };

    nativeBuildInputs = [ pkgs.gtk3 ];
    dontDropIconThemeCache = true;

    installPhase = ''
      mkdir -p $out/share/icons/Conflux
      cp -a . $out/share/icons/Conflux
      rm -rf $out/share/icons/Conflux/{Workspace,.github,.gitignore,LICENSE,*.md,*.png}
      find $out/share/icons/Conflux -xtype l -delete
      gtk-update-icon-cache $out/share/icons/Conflux
    '';
  };

  orchis-kde = pkgs.stdenvNoCC.mkDerivation {
    pname = "orchis-kde";
    version = "0-unstable-2025-10-18";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Orchis-kde";
      rev = "b2a96919eee40264e79db402b915f926436100ad";
      hash = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
    };

    installPhase = ''
      mkdir -p $out/share/Kvantum
      cp -a Kvantum/* $out/share/Kvantum/
    '';
  };

in
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis-Purple-Dark";
    };
    iconTheme = {
      name = "Conflux";
      package = conflux;
    };
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
    style.package = pkgs.libsForQt5.qtstyleplugin-kvantum;
  };

  home.packages = with pkgs; [
    gtk3
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    qt6.qtwayland
    qt5.qtwayland

    pkgs.qt6Packages.qtstyleplugin-kvantum
  ];

  xdg.configFile = {
    "Kvantum/Orchis".source = "${orchis-kde}/share/Kvantum/Orchis";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=OrchisDark
    '';
  };

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
