{ pkgs, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  networking = {
    # Enable networking
    networkmanager.enable = true;
  
    hostName = "nixos"; # Define your hostname.
    
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    
    firewall.enable = true;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [ ];
    firewall.allowedUDPPorts = [ ];


    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}
