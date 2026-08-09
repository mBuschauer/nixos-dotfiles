{ inputs, pkgs, ... }:
let
  anime_wallpapers = ./anime;
in
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "${anime_wallpapers}/reze_1.jpg";
          fit_mode = "cover";
        }
      ];
    };
  };
}
