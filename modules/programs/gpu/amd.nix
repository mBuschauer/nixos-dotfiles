{ pkgs, ... }:
{
  
  environment.systemPackages = with pkgs; [
    sigil
    jellyfin-media-player
  ];

}
