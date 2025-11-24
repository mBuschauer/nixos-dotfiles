{ inputs, pkgs, ... }:
let wallpapers = ./wallpapers;
in {
  home.packages = with pkgs;
    [
      # inputs.swww.packages.${pkgs.system}.swww
      # waypaper
    ];

  wayland.windowManager.hyprland.settings."exec-once" = [
    # "hyprpaper"
    # "swww-daemon"h
  ];

  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    settings = {
      preload = [
        "${wallpapers}/8bit/galaxies.png"
        "${wallpapers}/8bit/city_night_skyline.png"
        "${wallpapers}/8bit/dune_nightsky.png"
        "${wallpapers}/8bit/blackhole_universe.png"
      ];
      wallpaper = [ ",${wallpapers}/8bit/blackhole_universe.png" ];
    };
  };
}
