{
  pkgs,
  configs,
  inputs,
  aagl,
  settings,
  ...
}:
let
  retroarchWithCores = (
    pkgs.retroarch.withCores (
      cores: with cores; [
        desmume
        dolphin
        citra
      ]
    )
  );

in
{
  home-manager.users.${settings.userDetails.username} = {
    programs.retroarch = {
      enable = false;
      package = pkgs.retroarch-bare;
      cores = {
        citra.enable = true;
        dolphin.enable = true;
        desmume.enable = true;
      };
    };
    programs.mangohud = {
      enable = true;
      package = pkgs.mangohud;
      settings = {
        fps = true;
        font_size = 18;
        cpu_stats = false;
        gpu_stats = false;
        ram = false;
      };
    };
    programs.lutris = {
      enable = true;

      extraPackages = with pkgs; [
        winetricks
        umu-launcher
      ];

      winePackages = with pkgs; [
        wineWow64Packages.full
      ];

      protonPackages = with pkgs; [
        proton-ge-bin
      ];
      defaultWinePackage = pkgs.proton-ge-bin;
    };
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraPackages = with pkgs; [
      # mangohud # MANGOHUD_CONFIG=fps=1,font_size=18,cpu_stats=0,gpu_stats=0,ram=0 MANGOHUD=1 %command%
    ];
  };

  environment.systemPackages =
    with pkgs;
    [
      # retroarchWithCores
      azahar
      heroic

      # suyu
      # ryubing
      # nsz

      # wineWow64Packages.base
      # winetricks

      hydralauncher

      prismlauncher
      jdk21

    ]
    ++ [
    ];

  # services.foundryvtt = {
  #   enable = true;
  #   # hostName = settings.userDetails.hostname;
  #   package = inputs.foundryvtt.packages.${pkgs.stdenv.hostPlatform.system}.foundryvtt_12;
  #   minifyStaticFiles = true;
  #   # proxyPort = 8080;
  #   # proxySSL = true;
  #   # upnp = false;
  # };

  # programs.anime-games-launcher.enable = true;
}
