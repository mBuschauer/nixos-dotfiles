{ pkgs, settings, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  networking = {
    # Enable networking
    networkmanager.enable = true;


    hostName = "${settings.userDetails.hostname}"; # Define your hostname.

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    firewall.enable = true;
    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };


    # Or disable the firewall altogether.
    # firewall.enable = false;

  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  # sudo tailscale set --exit-node=xxx

  programs.firejail.enable = true;

  environment.systemPackages = with pkgs; [
    traceroute
    inetutils
  ];
}
