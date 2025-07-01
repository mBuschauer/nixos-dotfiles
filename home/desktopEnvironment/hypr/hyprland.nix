{ inputs, pkgs, settings, ... }:
let
  notification =
    "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";

in {
  home.packages = with pkgs; [
    dmenu-rs # seems to be a dunst dependency?

    # used for clipboard history (SUPER + V)
    wl-clipboard
    stable.cliphist

    satty # for screenshot editing (will be implemented at some point)

    # kando
  ];

  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
        follow = "mouse";
        shrink = "yes";
        # mouse = true;
        notification_height = 0;

        # Text and seperator padding
        padding = 8;
        # Horizontal padding
        horizontal_padding = 8;

        # Split notifications into multiple lines
        word_wrap = "no";
        # If message too long, add ellipsize to...
        ellipsize = "middle";
        # Ignore newlines in notifications
        ignore_newline = "no";
        # Stack duplicate notifications
        stack_duplicates = true;
        # Hide number of duplicate notifications
        hide_duplicate_count = true;

        mouse_left_click = "do_action";
        mouse_right_click = "close_menu";

        dmenu = "${pkgs.dmenu-rs}/bin/dmenu -l 10 -w 10 -p dunst";
        # dmenu = "${pkgs.wofi}/bin/wofi --demnu --prompt \"dunst\" --insensitive";
        # Browser
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        # Always run scripts
        always_run_script = true;
        # Print notification on startup
      };

    };
  };

  wayland.windowManager.hyprland = {
    # systemd.variables = ["--all"];
    enable = true;

    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    # systemd.enable = false;
    # xwayland.enable = false;
    settings = {
      monitor = settings.customization.monitors;
      #env = [
      #  "HYPRCURSOR_THEME,${cursorName}"
      #  "HYPRCURSOR_SIZE,${toString pointerSize}"
      #];

      "exec-once" = [
        "swww-daemon"
        "waybar"
        # "hyprctl setcursor ${cursorName} ${toString pointerSize}"
        "wl-paste --watch cliphist store"
        #"xdg-terminal-exec ncspot"
        "easyeffects --gapplication-service"

        # "nwg-dock-hyprland -c anyrun -i 36 -lp start -p bottom -a start -mb 10"

        # "xwaylandvideobridge"
        #"mpd-mpris"
        # "discord --start-minimized" # starts discord before waybar so icon doesnt show up anyway
        "systemctl --user start hyprpolkitagent" # start polkit
      ];

      "env" = [ ];

      cursor = { no_hardware_cursors = true; };

      input = {
        sensitivity = -0.2;
        follow_mouse = 2;
      };

      general = {
        gaps_in = 1;
        gaps_out = 1;
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
        pseudotile = true;
        preserve_split = true;
      };

      misc = { force_default_wallpaper = 0; };

      layerrule = [
        # "noanim,^(anyrun)$" # disable animation for anyrun pop-in
        "animation[fadeIn],^(anyrun)$"
      ];

      windowrule = [
        # "noblur, kando"
        # "opaque, kando"
        # "size 100% 100%, kando"
        # "noborder, kando"
        # "noanim, kando"
        # "float, kando"
        # "pin, kando"
      ];

      windowrulev2 = [
        "maximize,class:(okular)"

        # force all only office windows to open maximized
        "maximize,class:(ONLYOFFICE Desktop Editors)"

        "maximize,class:(sigil),title:(.*)( - Sigil [std])$"
        "maximize,class:(sigil),title:(.*)( - Sigil)$"
        # "maximize,class:(sigil)"
        "float,class:(CoreArchiver)"
        "float,class:(qimgv)"
        "float,class:(pqiv)"

        # for screensharing under XWayland (like Discord)
        # "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        # "noanim,class:^(xwaylandvideobridge)$"
        # "noinitialfocus,class:^(xwaylandvideobridge)$"
        # "maxsize 1 1,class:^(xwaylandvideobridge)$"
        # "noblur,class:^(xwaylandvideobridge)$"

        # # enable smart gaps / no gaps when only
        # "bordersize 0, floating:0, onworkspace:w[tv1]"
        # "rounding 0, floating:0, onworkspace:w[tv1]"
        # "bordersize 0, floating:0, onworkspace:f[1]"
        # "rounding 0, floating:0, onworkspace:f[1]"
      ];

      workspace = [
        "f[1], gapsout:0, gapsin:0, bordersize: 0, rounding:0" # if an app is full screen, show no borders

        # # enable smart gaps / no gaps when only
        # "w[tv1], gapsout:0, gapsin:0"
      ];

      "$mod" = "SUPER";
      bind = [
        #"$mod, SPACE, overview:toggle"
        "$mod, F, exec, firefox"

        # "CTRL, Space, global, kando:example-menu"

        "$mod, P, exec, ${
          pkgs.writeShellScript "sent_notification" ''
            TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
            MONTH_YEAR=$(date +'%B_%Y')  # e.g., April_2025
            SCREENSHOT_DIR=~/Pictures/Screenshots/$MONTH_YEAR
            mkdir -p "$SCREENSHOT_DIR"
            SCREENSHOT_PATH="$SCREENSHOT_DIR/Screenshot_$TIMESTAMP.png"

            # Take screenshot with grim, but check if slurp/grim was cancelled
            grim -g "$(slurp)" "$SCREENSHOT_PATH"
            if [ $? -ne 0 ]; then
              echo "Screenshot cancelled or failed."
              exit 1
            fi

            ${notification}

            # Function to open the folder where screenshot was saved
            forward_action() {
              xdg-open "$SCREENSHOT_DIR"
            }

            # Function to handle notification dismiss
            handle_dismiss() {
              echo "Notification dismissed!"
            }

            # Display the notification with actions
            ACTION=$(dunstify --action="forward,Forward" "Screenshot Taken" "$SCREENSHOT_PATH")

            # Handle the selected action
            case "$ACTION" in
              "forward")
                forward_action
                ;;
              "2")  # Dunst returns "2" when the notification is manually dismissed
                handle_dismiss
                ;;
              *)
                echo "No valid action selected."
                ;;
            esac
          ''
        }"
        "$mod, Print, exec, ${
          pkgs.writeShellScript "active-window" ''
            w_pos=$(hyprctl activewindow | grep 'at:' | awk '{print $2}' | tr -d ' ')
            w_size=$(hyprctl activewindow | grep 'size:' | awk '{print $2}' | tr -d ' ' | sed 's/,/x/')
            geometry="$w_pos $w_size"

            TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
            MONTH_YEAR=$(date +'%B_%Y')
            SCREENSHOT_DIR=~/Pictures/Screenshots/$MONTH_YEAR
            mkdir -p "$SCREENSHOT_DIR"
            SCREENSHOT_PATH="$SCREENSHOT_DIR/Screenshot_$TIMESTAMP.png"
            ANNOTATED_PATH="$SCREENSHOT_DIR/Screenshot_Annotated_$TIMESTAMP.png"

            # Take a screenshot of the active window
            grim -g "$geometry" "$SCREENSHOT_PATH"
            ${notification}

            # Function to open the folder where screenshot was saved
            forward_action() {
              xdg-open "$SCREENSHOT_DIR"
            }

            # Function to handle notification dismiss
            handle_dismiss() {
              echo "Notification dismissed!"
            }

            # Display the notification with actions
            ACTION=$(dunstify --action="forward,Forward" "Screenshot Taken" "$SCREENSHOT_PATH")

            # Handle the selected action
            case "$ACTION" in
              "forward")
                forward_action
                ;;
              "2")
                handle_dismiss
                ;;
              *)
                echo "No valid action selected."
                ;;
            esac

            return 0
          ''
        }"

        "$mod, Space, togglesplit"

        "$mod, K, exec, pkill waybar; sleep 0.5 && waybar"

        "$mod, R, exec, systemctl --user restart pipewire.service"

        # "$mod, Q, exec, xdg-terminal-exec bash -c \"cd /home/${settings.userDetails.username}/ ; /home/marco/.config/.pokemon-icat/pokemon-icat; exec bash\""
        ''
          $mod, Q, exec, xdg-terminal-exec bash -c "cd /home/${settings.userDetails.username}/; exec bash"''

        "$mod, C, killactive"
        "$mod, E, exec, dolphin"
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
        # ",F1,overview:toggle" # for hyprspace
        # ",F1,hyprexpo:expo,toggle" # for hyprexpo
      ];

      bindr = [
        # "$mod, $mod_L, exec, pkill wofi || wofi --show drun --insensitive --allow-images"
        # "$mod, $mod_L, exec, pkill fuzzel || fuzzel"
        "$mod, V, exec, pkill wofi || cliphist list | wofi --dmenu --insensitive | cliphist decode | wl-copy"
        # "$mod, V, exec, pkill anyrun || cliphist list | anyrun --plugins libstdin.so | cliphist decode | wl-copy" # no work
        "$mod, SUPER_L, exec, pkill anyrun || anyrun"

      ];
      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
    };

    plugins = builtins.attrValues {
      inherit (pkgs.hyprlandPlugins)
      # hyprspace 
      # split-monitor-workspaces
      ;
    } ++ [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
  };
}
