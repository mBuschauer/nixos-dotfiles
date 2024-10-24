{ inputs, pkgs, ... }:
let
  notification = "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";
in
{
  home.packages = with pkgs; [
    dmenu-rs # seems to be a dunst dependency?

    # used for clipboard history (SUPER + V)
    wl-clipboard
    stable.cliphist
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
    # systemd.enable = false;
    # xwayland.enable = false;
    settings = {
      monitor=[
        "HDMI-A-1, preferred, 1920x0, 1"
        "DP-1, preferred, 0x0, 1"
      ];

      #env = [
      #  "HYPRCURSOR_THEME,${cursorName}"
      #  "HYPRCURSOR_SIZE,${toString pointerSize}"
      #];
      
      "exec-once" = [
        "waybar"
        # "hyprctl setcursor ${cursorName} ${toString pointerSize}"
        "wl-paste --watch cliphist store"
        #"kitty -e ncspot"
        "easyeffects --gapplication-service" 
        # "xwaylandvideobridge"
        #"mpd-mpris"
        # "discord --start-minimized" # starts discord before waybar so icon doesnt show up anyway
      ];

      "env" = [
        "GBM_BACKEND,nvidia-drm"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      cursor = {
        "no_hardware_cursors" = true;
      };

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
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

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

      misc = {
        force_default_wallpaper = 0;
      };

      layerrule = [
        # "noanim,^(wofi)$" # disable animation for wofi pop-in (it looks like shit tho)
        "animation[fadeIn],^(wofi)$"
      ];

      windowrulev2 = [ 
        "maximize,class:(okular)"

        "maximize,class:(sigil),title:(.*)( - Sigil [std])$"
        "maximize,class:(sigil),title:(.*)( - Sigil)$"
        "float,class:(ark)"
        "float,class:(qimgv)"
	
	      # for screensharing under XWayland (like Discord)
	      # "opacity 0.0 override,class:^(xwaylandvideobridge)$"
	      # "noanim,class:^(xwaylandvideobridge)$"
	      # "noinitialfocus,class:^(xwaylandvideobridge)$"
	      # "maxsize 1 1,class:^(xwaylandvideobridge)$"
	      # "noblur,class:^(xwaylandvideobridge)$"
      ];

      workspace = [
        "f[1], gapsout:0, gapsin:0, border: 0, rounding:0"
      ];


      "$mod" = "SUPER";
      bind = [
        #"$mod, SPACE, overview:toggle"
        "$mod, F, exec, firefox"
        # screenshot

        # pkgs.writeShellScript "get_nvidia_gpu" ''
        # notify-send 'Screenshot Taken' \"~/Pictures/screenshot-$(date +%Y%m%d%H%M%S).png\" 
        "$mod, P, exec, ${pkgs.writeShellScript "sent_nofification" ''
          STAMP=$(date +%Y%m%d%H%M%S)
          SCREENSHOT_PATH=~/Pictures/screenshot-$STAMP.png

          # Take screenshot with grim, but check if slurp/grim was cancelled
          grim -g "$(slurp)" "$SCREENSHOT_PATH"
          if [ $? -ne 0 ]; then
            echo "Screenshot cancelled or failed."
            exit 1
          fi


          ${notification}

          # Function to open the Pictures folder
          forward_action() {
            xdg-open ~/Pictures/
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
        ''}" 
        

        
        "$mod, Space, togglesplit"

        "$mod, K, exec, pkill waybar; sleep 0.5 && waybar"

        "$mod, R, exec, systemctl --user restart pipewire.service"

        # "$mod, Q, exec, kitty --hold /home/marco/.config/.pokemon-icat/pokemon-icat"
        "$mod, Q, exec, kitty"
        
        "$mod, C, killactive"
        "$mod, E, exec, dolphin"
        # "$mod, E, exec, kitty -e yazi"
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
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
    
    plugins = builtins.attrValues { inherit (pkgs.hyprlandPlugins)
      # hyprspace 
      # split-monitor-workspaces
      ; 
    } ++ [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
  };
}
