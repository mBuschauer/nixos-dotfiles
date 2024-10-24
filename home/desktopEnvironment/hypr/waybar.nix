{ pkgs, inputs, secrets, ... }:
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
        output = [
          "HDMI-A-1"
          "DP-1"
        ];
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
          on-click = "kitty -e btm";
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
          format-ethernet = " {bandwidthDownBits} {bandwidthUpBits}";
          format-disconnected = "No connection";
          format-alt = " {ipaddr}/{cidr}";
          tooltip = false;
        };

        "memory" = {
          interval = 5;
          format = " {percentage}%";
          format-alt = "  {used:.1f}G/{total:.1f}G";
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
          on-click = "kitty -e btm";
        };

        "custom/hardware" = {
          format = "  ";
          tooltip = false;
          on-click = "kitty -e btm";
        };

        "custom/shutdownmenu" = {
          format = "󰍜 ";
          tooltip = false;
          on-click = "wlogout -b 2";
        };

        "custom/shutdown" = {
          format = " ";
          on-click = "poweroff";
          tooltip-format = "shutdown";
        };

        "custom/reboot" = {
          format = " ";
          on-click = "reboot";
          tooltip-format = "reboot";
        };

        "custom/lock" = {
          format = " ";
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


    style = ''
        /* Keyframes */

        @keyframes blink-critical {
       	to {
      		/*color: @white;*/
      		background-color: @critical;
       	}
        }


        /* Styles */

        /* Colors (gruvbox) */
        @define-color black	#282828;
        @define-color red	#cc241d;
        @define-color green	#98971a;
        @define-color yellow	#d79921;
        @define-color blue	#458588;
        @define-color purple	#b16286;
        @define-color aqua	#689d6a;
        @define-color gray	#a89984;
        @define-color brgray	#928374;
        @define-color brred	#fb4934;
        @define-color brgreen	#b8bb26;
        @define-color bryellow	#fabd2f;
        @define-color brblue	#83a598;
        @define-color brpurple	#d3869b;
        @define-color braqua	#8ec07c;
        @define-color white	#ebdbb2;
        @define-color bg2	#504945;
        @define-color bluetest #6D9BB8;
        @define-color salmonPink #FF9FB2;
        @define-color IndianRed #E65F5C;
        @define-color pastelBlue #97b4d1;


        @define-color warning 	@bryellow;
        @define-color critical	@red;
        @define-color mode	@black;
        @define-color unfocused	@bg2;
        @define-color focused	@braqua;
        @define-color inactive	@purple;
        @define-color sound	@brpurple;
        @define-color network	@brblue;
        @define-color memory	@IndianRed;
        @define-color cpu	@green;
        @define-color temp	@brgreen;
        @define-color layout	@bryellow;
        @define-color battery	@aqua;
        @define-color date	@black;
        @define-color time	@white;
        @define-color logout	@white;
        @define-color disk @bryellow;
        @define-color gpu @pastelBlue;
        @define-color weather @braqua;
        @define-color hardwareGroup @bluetest;


        /* Reset all styles */
        * {
       	border: none;
       	border-radius: 0;
       	min-height: 0;
       	margin: 0;
       	padding: 0;
       	box-shadow: none;
       	text-shadow: none;
       	icon-shadow: none;
        }

        /* The whole bar */
        #waybar {
       	background: rgba(40, 40, 40, 0.8784313725); /* #282828e0 */
       	color: @white;
       	font-family: JetBrains Mono, Siji;
       	font-size: 10pt;
       	/*font-weight: bold;*/
        }

        /* Each module */
        #battery,
        #clock,
        #cpu,
        #cava,
        #disk,
        #language,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #custom-pipewire
        #temperature,
        #tray,
        #backlight,
        #idle_inhibitor,
        #disk,
        #user,
        #custom-hardware,
        #mpris,
        #custom-gpu,
        #weather{
       	padding-left: 8pt;
       	padding-right: 8pt;
        }

        #custom-waybar-mpris{
        padding-left: 15pt;
        }

        /* Each critical module */
        #mode,
        #memory.critical,
        #cpu.critical,
        #temperature.critical,
        #battery.critical.discharging {
       	animation-timing-function: linear;
       	animation-iteration-count: infinite;
       	animation-direction: alternate;
       	animation-name: blink-critical;
       	animation-duration: 1s;
        }

        /* Each warning */
        #network.disconnected,
        #memory.warning,
        #cpu.warning,
        #temperature.warning,
        #battery.warning.discharging {
       	color: @warning;
        }


        /* Each shutdown option */
        #custom-logout,
        #custom-lock,
        #custom-shutdown,
        #custom-shutdownmenu,
        #custom-reboot{
        font-size: 11pt;
        color: @white;
        background: transparent;
        padding-right: 6pt;
        padding-left: 6pt;
        }

        /* And now modules themselves in their respective order */

        /* Current sway mode (resize etc) */
        #mode {
       	color: @white;
       	background: @mode;
        }

        #cava {
        padding-left: 0;
        color: @black;
        background: @sound;
        }

        /* Workspaces stuff */
        #workspaces button {
       	/*font-weight: bold;*/
       	padding-left: 2pt;
       	padding-right: 2pt;
       	color: @white;
       	background: @unfocused;
        }

        /* Inactive (on unfocused output) */
        #workspaces button.visible {
       	color: @white;
       	background: @inactive;
        }

        /* Active (on focused output) */
        #workspaces button.focused {
       	color: @black;
       	background: @focused;
        }

        /* Contains an urgent window */
        #workspaces button.urgent {
       	color: @black;
       	background: @warning;
        }

        /* Style when cursor is on the button */
        #workspaces button:hover {
       	background: @black;
       	color: @white;
        }

        #window {
       	margin-right: 35pt;
       	margin-left: 35pt;
        }

        #pulseaudio {
       	background: @sound;
       	color: @black;
        }

        #custom-pipewire {
       	background: @sound;
       	color: @black;
        }

        #network {
       	background: @network;
       	color: @black;
        }

        #memory {
       	background: @memory;
       	color: @black;
        }

        #cpu {
       	background: @cpu;
       	color: @white;
        }

        #custom-hardware{
        padding-right: 0pt;
        background: @hardwareGroup;
        color: @black;
        }

        #custom-groupHardware {
        font-size: 11pt;
        color: @hardwareGroup;
        background: @black;
        }

        #disk {
        background: @disk;
        color: @black;
        }

        #custom-gpu {
        background: @gpu;
        color: @black;
        }

        #temperature {
       	background: @temp;
       	color: @black;
        }

        #language {
       	background: @layout;
       	color: @black;
        }

        #battery {
       	background: @battery;
       	color: @white;
        }

        #tray {
       	background: @date;
        }

        #clock.date {
       	background: @date;
       	color: @white;
        }

        #clock.time {
       	background: @time;
       	color: @black;
        }

        #custom-arrow1 {
       	font-size: 11pt;
       	color: @time;
       	background: @date;
        }

        #custom-arrow2 {
       	font-size: 11pt;
       	color: @date;
       	background: @cpu;
        }

        #custom-arrow3 {
       	font-size: 11pt;
       	color: @disk;
       	background: @network;
        }

        #custom-arrow4 {
       	font-size: 11pt;
       	color: @memory;
       	background: @disk;
        }

        #custom-arrow5 {
       	font-size: 11pt;
       	color: @network;
       	background: @black;
        }

        #custom-arrow6 {
       	font-size: 11pt;
       	color: @cpu;
       	background: @gpu;
        }

        #custom-arrow7 {
       	font-size: 11pt;
       	color: @black;
       	background: @sound;
        }

        #custom-arrow8 {
       	font-size: 11pt;
       	color: @black;
       	background: @time;
        }

        #custom-arrow9 {
       	font-size: 11pt;
       	color: @gpu;
       	background: @memory;
        }

        #custom-arrow11 {
       	font-size:11pt;
       	color: @sound;
       	background: @weather;
        padding-left: 5pt;
        }

        #custom-arrow10 {
       	font-size: 11pt;
       	color: @unfocused;
       	background: transparent;
        }

        #custom-arrow13 {
        font-size: 11pt;
        color: @weather;
        background: @hardwareGroup;
        }

        #custom-weather {
        color: @black;
        background: @weather;
        }
    '';
  };
}
