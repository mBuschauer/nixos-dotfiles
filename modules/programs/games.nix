{ pkgs, configs, inputs, aagl, ... }:
let
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
    desmume
    dolphin
    citra
  ]));

in
{
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraPackages = with pkgs; [
      mangohud # MANGOHUD_CONFIG=fps=1,font_size=18,cpu_stats=0,gpu_stats=0,ram=0 MANGOHUD=1 %command%
    ];
  };
  environment.systemPackages = with pkgs; [
    heroic
    retroarchWithCores

  ] ++ [
    inputs.suyu.packages.${system}.suyu # yuzu successor
  ];

  # programs.anime-games-launcher.enable = true;
}
