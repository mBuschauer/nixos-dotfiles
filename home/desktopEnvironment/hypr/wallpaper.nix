{ ... }:
let
  wallpapers = "/etc/nixos/home/desktopEnvironment/hypr/wallpapers";
in
{
  wayland.windowManager.hyprland.settings."exec-once" = [
    # "hyprpaper"
    # "swww-daemon"
  ];

  services.hyprpaper.settings = {
    enable = false;
    settings = {
      preload = [
        # "./wallpapers/nixos/pastel_gay_nix.png"
        "${wallpapers}/8bit/galaxies.png"
        "${wallpapers}/8bit/city_night_skyline.png"
        "${wallpapers}/8bit/dune_nightsky.png"
        "${wallpapers}/8bit/blackhole_universe.png"
      ];
      wallpaper = [
        # ",wallpapers/8bit/galaxies.png"
        ",${wallpapers}/8bit/blackhole_universe.png"
      ];
    };
  };

  programs.hyprlock.settings.background = [
    {
      monitor = "";
      path = "${wallpapers}/8bit/blackhole_universe.png";
      blur_size = 4;
      blur_passes = 3; # 0 disables blurring
      noise = 0.0117;
      contrast = 1.3; # vibrant
      brightness = 0.8;
      vibrancy = 0.21;
      vibrancy_darkness = 0;
    }
  ];
}
