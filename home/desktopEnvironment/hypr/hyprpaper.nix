{ inputs, pkgs, ...}:
{
  services.hyprpaper = {
    package = inputs.hyprpaper.packages."${pkgs.system}".hyprpaper;
    settings = { 
      splash = true;
    };
  };
}
