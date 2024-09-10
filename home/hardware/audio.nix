{ pkgs, ... }:
{

  services.mpd = {
    enable = true;
    musicDirectory = "/home/marco/Music/";
    #user = "marco";
  
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
