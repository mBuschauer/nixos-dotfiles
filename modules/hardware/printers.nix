{ pkgs, settings, secrets, ... }: {
  # enable printing
  services.printing = {
    # http://localhost:631/
    enable = settings.customization.cups_enabled;
    drivers = with pkgs; [ gutenprint hplip ];
    openFirewall = settings.customization.cups_enabled;
  };

  hardware.printers = {
    ensurePrinters = secrets.printers;
  };

  services.avahi = {
    enable = settings.customization.cups_enabled;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = settings.customization.cups_enabled;
  };
}
