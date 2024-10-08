{ pkgs, ... }:
{
  services.xserver.enable = true;
  # services.displayManager.defaultSession = "plasma"; # set to plasmax11 to switch to x11
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # plasma-browser-integration
    # konsole
    # oxygen
  ]; 
}