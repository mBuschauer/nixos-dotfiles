{ pkgs, settings, ... }:
{

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${settings.username}/Music/";
  
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "MPD PipeWire Output"
      }
    ''; 
  };

  # so headphone can control audio, etc.
  services.mpris-proxy.enable = true;
}
