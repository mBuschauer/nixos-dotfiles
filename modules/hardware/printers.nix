{ pkgs, ... }:

{
  # enable printing
  services.printing = {
    enable = false; # disabled because of CUPs vulnerability 
    drivers = with pkgs; [gutenprint hplip];
    openFirewall = false; # disabled because of CUPs vulnerability 
  };

  services.avahi  = {
    enable = false; # disabled because of CUPs vulnerability 
    nssmdns4 = true;
    openFirewall = false; # disabled because of CUPs vulnerability 
  };
}
