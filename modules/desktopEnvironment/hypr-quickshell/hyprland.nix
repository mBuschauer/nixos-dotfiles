{
  inputs,
  pkgs,
  settings,
  ...
}:
let
  notification = "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";

  open-menu = "rofi -show drun";
  close-menu = "pkill rofi";
  open-clipboard = "rofi -modi clipboard:cliphist-rofi -show clipboard";
in
{
  home = {
    packages = with pkgs; [
      dmenu-rs
      wl-clipboard
      cliphist
      inputs.hyprpolkitagent.packages.${pkgs.stdenv.hostPlatform.system}.hyprpolkitagent
      sox # for playing a notification sound
      wayvnc
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
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
    configType = "hyprlang";

    settings = {
      monitor = settings.customization.monitors;

      "exec-once" = [
        "wl-paste --watch cliphist store"
        "easyeffects --gapplication-service"
        "systemctl --user start hyprpolkitagent"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      input = {
        sensitivity = -0.2;
        follow_mouse = 2;
      };

      general = {
        gaps_in = 1;
        gaps_out = 0;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        layout = "dwindle";
        allow_tearing = true;
      };

      decoration = {
        rounding = 2;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "layersIn, 1, 3, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "fadeIn, 1, 3, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
      };

      debug = {
        disable_logs = false;
      };

      windowrule = [
        "match:class okular, maximize on"

        # force all only office windows to open maximized
        "match:class ONLYOFFICE Desktop Editors, maximize on"

        "match:title (.*)( - Sigil [std])$, maximize on"
        "match:title (.*)( - Sigil)$, maximize on"

        "match:class CoreArchiver, float on"
        "match:class qimgv, float on"
        "match:class pqiv, float on"
      ];

      workspace = [
        "f[1], gapsout:0, gapsin:0, bordersize: 0, rounding:0" # if an app is full screen, show no borders
      ];

      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"

        "$mod, Space, layoutmsg, togglesplit"

        # "$mod, K, exec, pkill waybar; sleep 0.5 && waybar"

        # "$mod, R, exec, systemctl --user restart pipewire.service"

        ''$mod, Q, exec, xdg-terminal-exec bash -c "cd /home/${settings.userDetails.username}/; exec bash"''

        "$mod, C, killactive"
        "$mod, E, exec, nemo"
        # "$mod, E, exec, xdg-terminal-exec yazi"
        "$mod, Z, togglefloating"

        # move focus with mainMod  + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # move active window to a worksapce with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        ",F11,fullscreen,1"
        "$mod,F11,fullscreen,2"
        "$mod, o, pin"
      ];

      bindr = [
        "$mod, V, exec, ${close-menu} || ${open-clipboard}"
        "$mod, SUPER_L, exec, ${close-menu} || ${open-menu}"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

    };
  };
}
