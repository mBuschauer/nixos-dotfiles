{
  inputs,
  pkgs,
  settings,
  lib,
  ...
}:
let
  notification = "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";

in
{
  home = {
    packages = with pkgs; [
      dmenu-rs # seems to be a dunst dependency?

      # used for clipboard history (SUPER + V)
      wl-clipboard
      cliphist

      # kando
      inputs.hyprpolkitagent.packages.${pkgs.stdenv.hostPlatform.system}.hyprpolkitagent
      inputs.hyprshutdown.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown
      hyprcursor

      sox # for playing a notification sound

      # grim
      # slurp
      wayvnc

      inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    ];
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
      hyprcursor = {
        enable = true;
        size = 24;
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    configType = "lua";
 
    settings.monitor = settings.customization.monitors;
    extraLuaFiles = {
      vars.content = ./hyprland/vars.lua;
      looknfeel.content = ./hyprland/looknfeel.lua;
      animations.content = ./hyprland/animations.lua;
      autostart.content = ./hyprland/autostart.lua;
      binds.content = ./hyprland/binds.lua;
      rules.content = ./hyprland/rules.lua;
    };
  };
}
