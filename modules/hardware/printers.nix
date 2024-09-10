{ pkgs, ... }:

{
  # enable printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint hplip];
  };

  services.avahi  = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
