{ inputs, pkgs, ...}:
let
  notification = "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";
in
{
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".hypridle;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        # ignore_dbus_inhibit = true; # whether to ignore dbus-sent idle inhibit events (e.g. from firefox)
        #before_sleep_cmd = "pidof hyprlock || hyprlock";
        # after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 480; # 8 min
          on-timeout = "notify-send \"Locking in 2 Minutes\" \"at $(date -d '+2 minutes' +%H:%M)\" && ${notification}";

        }
        {
          timeout = 600; # 10 min
          on-timeout = "hyprlock";
        }

        {
          timeout = 900; # 15 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
