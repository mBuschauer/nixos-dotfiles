{ pkgs, configs, inputs, aagl, ... }:
let
in
{
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraPackages = with pkgs; [
      mangohud
    ];
  };
  environment.systemPackages = with pkgs; [
    heroic
  ];
  
  # programs.anime-games-launcher.enable = true;
}
