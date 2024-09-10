{ pkgs, config,... }:
{  
   swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];

  environment.systemPackages = with pkgs; [
    # for hardware accelerated video encoding
    libva-utils
    ffmpeg_7-full
  ];

  
}
