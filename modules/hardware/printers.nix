{ pkgs, settings, ... }:
{
  # enable printing
  services.printing = {
    enable = settings.customization.cups_enabled; 
    drivers = with pkgs; [gutenprint hplip];
    openFirewall = settings.customization.cups_enabled;
  };

  services.avahi  = {
    enable = settings.customization.cups_enabled;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = settings.customization.cups_enabled;
  };
}
