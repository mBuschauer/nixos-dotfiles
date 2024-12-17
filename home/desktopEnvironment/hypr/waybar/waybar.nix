{ pkgs, inputs, settings, secrets, ... }:
let
  # Function to extract the EDID name (everything up to the first comma)
  getEdidName = monitor: builtins.head (builtins.split "," monitor);

  # Extract the names
  edidNames = builtins.map getEdidName monitors;
in
{

  home.packages = with pkgs; [
    gpustat
    wttrbar
    waybar-mpris
    glxinfo
    bc
    # pw-volume
  ];
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages."${pkgs.system}".waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = edidNames settings.customization.monitors;
        modules-left = [ "hyprland/workspaces" "custom/arrow10" "custom/waybar-mpris" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "group/hardware"
          "custom/hardware"
          "custom/arrow13"
          "custom/weather"
          "custom/arrow11"
          "pulseaudio"
          # "custom/pipewire"
          "cava"
          "custom/arrow7"
          "tray"
          "clock#date"
          "custom/arrow1"
          "clock#time"
          "custom/arrow8"
          "group/power"
        ];

        "group/power" = {
          orientation = "horizontal";
          drawer = {
            transition-left-to-right = false;
            transition-duration = 500;
          };
          modules = [
            "custom/shutdownmenu"
            "custom/logout"
            "custom/lock"
            "custom/shutdown"
            "custom/reboot"
          ];
        };

        "group/hardware" = {
          orientation = "horizontal";
          drawer = {
            transition-left-to-right = false;
            transition-duration = 1000;
          };
          modules = [
            "custom/groupHardware"
            "custom/arrow5"
            "network"
            "custom/arrow3"
            "disk"
            "custom/arrow4"
            "memory"
            "custom/arrow9"
            "custom/gpu"
            "custom/arrow6"
            "cpu"
            "custom/arrow2"
          ];
        };

        "cava" = {
          framerate = 30;
          autosens = 1;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pipewire";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          noise_reduction = 0.4;
          input_delay = 1;
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          on-click = "easyeffects";
        };

        "custom/waybar-mpris" = {
          return-type = "json";
          exec = "waybar-mpris --autofocus --interpolate --pause \"\\uf04d\" --order \"SYMBOL:TITLE:ARTIST:POSITION\" --position";
          on-click = "waybar-mpris --send toggle";
          tooltip = true;
          escape = true;
          max-length = 50;
        };

        "clock#time" = {
          interval = 10;
          format = "{:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 20;
          format = "{:%e %b %Y}";
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "";
            # on-scroll = 1;
            weeks = "{:%W}";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'>{}</span>";
              weeks = "<span color='#99ffdd'>W{}</span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            on-click = "shift_up";
            on-click-middle = "shift_reset";
            on-click-right = "shift_down";
          };
        };

        "cpu" = {
          interval = 5;
          tooltip = true;
          format = "  {usage}%";
          on-click = "xdg-terminal-exec btm";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "custom/gpu" = {
          format = "󰨇  {}%";
          tooltip = true;
          return-type = "json";
          interval = 1;
          on-click = "gpustat";
          exec = pkgs.writeShellScript "get_nvidia_gpu" ''
            # Fetch GPU usage percentage
            gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

            # Fetch GPU temperature
            gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

            # Fetch driver version
            driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

            # Fetch total and used memory
            total_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
            used_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)

            # Fetch GPU name
            gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader)

            # Create the JSON output
            json_output=$(cat <<EOF
            {"text": "$gpu_usage","tooltip": "GPU Name: $gpu_name\nUsed Memory: $used_memory MiB / $total_memory MiB\nTemperature: $gpu_temp°C\nDriver Version: $driver_version"}
            EOF
            )

            # Output the JSON
            echo "$json_output" 
          '';
        };

        "custom/weather" = {
          format = " {}°";
          tooltip = true;
          interval = 3600;
          exec = "wttrbar --location '${secrets.location}' --mph --hide-conditions --date-format %m/%d/%Y";
          return-type = "json";
          on-click = "xdg-open https://www.accuweather.com";
        };

        "disk" = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          format-alt = "󰋊 {used}/{total}";
          path = "/";
        };

        "network" = {
          interval = 5;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = "  {bandwidthDownBits} {bandwidthUpBits}";
          format-disconnected = "No connection";
          format-alt = "󰈀 {ipaddr}/{cidr}";
          tooltip = false;
        };

        "memory" = {
          interval = 5;
          format = "  {percentage}%";
          format-alt = "  {used:.1f}G/{total:.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
          tooltip = true;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          # max-length = 100;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll-wraparound = true;
          smooth-scaling-threshold = 4;
          enable-bar-scroll = 4;
          format = "{name}";
        };

        "tray" = {
          icon-size = 18;
        };

        "pulseaudio" = {
          format = "{volume}%";
          format-bluetooth = " {volume}%";
          format-muted = "";
          scroll-step = 1;
          on-click = "blueman-manager";
          tooltip = false;
        };


        "custom/groupHardware" = {
          format = "";
          tooltip = false;
          on-click = "xdg-terminal-exec btm";
        };

        "custom/hardware" = {
          format = "  ";
          tooltip = false;
          on-click = "xdg-terminal-exec btm";
        };

        "custom/shutdownmenu" = {
          format = "󰍜 ";
          tooltip = false;
          on-click = "wlogout -b 2";
        };

        "custom/shutdown" = {
          format = "⏻ ";
          on-click = "poweroff";
          tooltip-format = "shutdown";
        };

        "custom/reboot" = {
          format = " ";
          on-click = "reboot";
          tooltip-format = "reboot";
        };

        "custom/lock" = {
          format = "󰌾 ";
          on-click = "hyprlock";
          tooltip-format = "lock";
        };

        "custom/logout" = {
          format = "󰗽 ";
          on-click = "hyprctl dispatch exit";
          tooltip-format = "logout";
        };

        "custom/arrow1" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow2" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow3" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow4" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow5" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow6" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow7" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow8" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow9" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow11" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow10" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow12" = {
          format = "";
          tooltip = false;
        };

        "custom/arrow13" = {
          format = "";
          tooltip = false;
        };
      };
    };


    style = builtins.readFile (./. + "/style.css");
  };
}
