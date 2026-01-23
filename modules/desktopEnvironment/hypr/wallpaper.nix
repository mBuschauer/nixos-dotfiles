{ inputs, pkgs, ... }:
let wallpapers = ./wallpapers;
in {
  home.packages = with pkgs;
    [
      # inputs.swww.packages.${pkgs.system}.swww
      # waypaper
      # inputs.hyprpaper.packages.${pkgs.system}.default
    ];

  wayland.windowManager.hyprland.settings."exec-once" = [
    # "hyprpaper"
    # "swww-daemon"h
  ];

  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "${wallpapers}/8bit/blackhole_universe.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
