{ pkgs, configs, inputs, aagl, settings, ... }:
let
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
    desmume
    dolphin
    citra
  ]));

in
{
  programs.gamemode.enable = true;

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

    # suyu
    ryubing
    nsz
    
    wineWow64Packages.base
    winetricks

  ] ++ [
  ];

  # services.foundryvtt = {
  #   enable = true;
  #   # hostName = settings.userDetails.hostname;
  #   package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12;
  #   minifyStaticFiles = true;
  #   # proxyPort = 8080;
  #   # proxySSL = true;
  #   # upnp = false;
  # };

  # programs.anime-games-launcher.enable = true;
}
