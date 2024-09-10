{ inputs, pkgs, ...}:
{
  services.hyprpaper = {
    enable =  true;
    package = inputs.hyprpaper.packages."${pkgs.system}".hyprpaper;
    settings = { 
      splash = true;
    };
  };
}
