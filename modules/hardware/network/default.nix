{ pkgs, settings, lib, ... }: {
  imports = lib.optional (settings.userDetails.hostname == "MarcoMNix")
    ./fix-deep-sleep.nix;

  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  networking = {
    # Enable networking
    networkmanager = {
      enable = true;
      wifi = { powersave = false; };
    };

    hostName = "${settings.userDetails.hostname}"; # Define your hostname.

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # turn off wifi: nmcli radio wifi off
    # turn on wifi: nmcli radio wifi on

    enableIPv6 = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    # sudo tailscale set --exit-node=xxx
  };

  programs.firejail.enable = true;

  environment.systemPackages = with pkgs; [ traceroute inetutils ];
}
