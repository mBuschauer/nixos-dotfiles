{ inputs, pkgs, ... }:
let
  notification = "play -n synth 1.5 sin 1760 synth 1.5 sin fmod 600 vol -20db fade l 0 1.5 1.5";
in
{
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 600; # 10 min
          # timeout = 5;
          on-timeout = "notify-send \"Locking in 5 Minutes\" \"at $(date -d '+5 minutes' +%H:%M)\" && ${notification}";

        }
        {
          timeout = 720; # 12 min
          # on-timeout = "loginctl lock-session";
        }

        {
          timeout = 900; # 15 min
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
          # on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
