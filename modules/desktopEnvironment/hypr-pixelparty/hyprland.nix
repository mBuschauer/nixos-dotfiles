{
  inputs,
  pkgs,
  settings,
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (lib) range concatMap;

  wsBinds = concatMap (i: [
    {
      _args = [
        (mkLuaInline ''mod .. " + ${toString i}"'')
        (mkLuaInline "hl.dsp.focus({ workspace = ${toString i} })")
      ];
    }
    {
      _args = [
        (mkLuaInline ''mod .. " + SHIFT + ${toString i}"'')
        (mkLuaInline "hl.dsp.window.move({ workspace = ${toString i} })")
      ];
    }
  ]) (range 1 9);
  
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
    # systemd.variables = ["--all"];
    enable = true;

    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    configType = "lua";
    # systemd.enable = false;
    # xwayland.enable = false;
    settings = {
      mod = {
        _var = "SUPER";
      };
      close_menu = {
        _var = "pkill rofi";
      };
      open_menu = {
        _var = "rofi -show drun";
      };
      open_clipboard = {
        _var = "rofi -modi clipboard:cliphist-rofi -show clipboard";
      };

      monitor = settings.customization.monitors;

      on = {
        _args = [
          "hyprland.start"
          (mkLuaInline ''
            function()
              hl.exec_cmd("wl-paste --watch cliphist store")
              hl.exec_cmd("easyeffects --gapplication-service")
              hl.exec_cmd("systemctl --user start hyprpolkitagent")
            end'')
        ];
      };

      config = {
        cursor.no_hardware_cursors = true;

        input = {
          sensitivity = -0.2;
          follow_mouse = 2;
        };

        general = {
          gaps_in = 1;
          gaps_out = 0;
          border_size = 1;
          col = {
            active_border = {
              colors = [
                "rgba(33ccffee)"
                "rgba(00ff99ee)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
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

        animations.enabled = true;
        dwindle.preserve_split = true;
        misc.force_default_wallpaper = 0;
        debug.disable_logs = false;
      };

      curve = {
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      };

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 3;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 3;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "default";
        }
      ];

      bind = [
        {
          _args = [
            (mkLuaInline ''mod .. " + F"'')
            (mkLuaInline ''hl.dsp.exec_cmd("firefox")'')
          ];
        }

        {
          _args = [
            (mkLuaInline ''mod .. " + P"'')
            (mkLuaInline ''
              hl.dsp.exec_cmd([[
                MONTH_YEAR=$(date +'%B_%Y')
                SCREENSHOT_DIR="$HOME/Pictures/Screenshots/$YEAR_MONTH"
                mkdir -p "$SCREENSHOT_DIR"
                XDG_SCREENSHOTS_DIR="$SCREENSHOT_DIR" grimblast --notify -o copysave area
              ]])'')
          ];
        }

        {
          _args = [
            (mkLuaInline ''mod .. " + Space"'')
            (mkLuaInline ''hl.dsp.layout("togglesplit")'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + K"'')
            (mkLuaInline ''hl.dsp.exec_cmd("pkill waybar; sleep 0.5 && waybar")'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + Q"'')
            (mkLuaInline ''hl.dsp.exec_cmd([[xdg-terminal-exec bash -c "cd $HOME/; exec bash"]])'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + C"'')
            (mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + E"'')
            (mkLuaInline ''hl.dsp.exec_cmd("nemo")'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + Z"'')
            (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + O"'')
            (mkLuaInline ''hl.dsp.window.pin({ action = "toggle" })'')
          ];
        }

        {
          _args = [
            (mkLuaInline ''mod .. " + left"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + right"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + up"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + down"'')
            (mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
          ];
        }

        {
          _args = [
            (mkLuaInline ''mod .. " + mouse_down"'')
            (mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'')
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + mouse_up"'')
            (mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'')
          ];
        }

        # Fullscreen. Old ",F11,fullscreen,1" -> mode 1 = maximize.
        {
          _args = [
            "F11"
            (mkLuaInline ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'')
          ];
        }
        # Old "$mod,F11,fullscreen,2" -> old mode 2 = "fake" fullscreen (window fills
        # the screen but the client isn't told). No 1:1 named mode now; regular
        # fullscreen is closest. For exact fake behavior use
        # hl.dsp.window.fullscreen_state({ internal = ..., client = ... }).
        {
          _args = [
            (mkLuaInline ''mod .. " + F11"'')
            (mkLuaInline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
          ];
        }

        # Release binds (old `bindr`) -> fire on key release
        {
          _args = [
            (mkLuaInline ''mod .. " + V"'')
            (mkLuaInline ''hl.dsp.exec_cmd(close_menu .. " || " .. open_clipboard)'')
            { release = true; }
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + SUPER_L"'')
            (mkLuaInline ''hl.dsp.exec_cmd(close_menu .. " || " .. open_menu)'')
            { release = true; }
          ];
        }

        # Mouse binds (old `bindm`)
        {
          _args = [
            (mkLuaInline ''mod .. " + mouse:272"'')
            (mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            (mkLuaInline ''mod .. " + mouse:273"'')
            (mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
      ]
      ++ wsBinds;

      #============ WINDOW RULES ============#
      window_rule = [
        {
          name = "okular-max";
          match.class = "okular";
          maximize = true;
        }
        {
          name = "onlyoffice-max";
          match.class = "ONLYOFFICE Desktop Editors";
          maximize = true;
        }
        {
          name = "sigil-std-max";
          match.title = "(.*)( - Sigil [std])$";
          maximize = true;
        }
        {
          name = "sigil-max";
          match.title = "(.*)( - Sigil)$";
          maximize = true;
        }
        {
          name = "corearchiver-float";
          match.class = "CoreArchiver";
          float = true;
        }
        {
          name = "qimgv-float";
          match.class = "qimgv";
          float = true;
        }
        {
          name = "pqiv-float";
          match.class = "pqiv";
          float = true;
        }
      ];

      #============ WORKSPACE RULES ============#
      workspace_rule = [
        # If an app is fullscreen, show no borders/gaps/rounding.
        {
          workspace = "f[1]";
          gaps_out = 0;
          gaps_in = 0;
          border_size = 0;
          no_rounding = true;
        }
        # Park a workspace on the headless output so windows have somewhere to live.
        {
          workspace = "99";
          monitor = "HEADLESS-1";
        }
      ];
    };

    plugins =
      builtins.attrValues {
        inherit (pkgs.hyprlandPlugins)
          # hyprspace
          # split-monitor-workspaces
          ;
      }
      ++ [
        # inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
        # inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
      ];
  };
}
