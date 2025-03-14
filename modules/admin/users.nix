{ pkgs, settings, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.userDetails.username} = {
    isNormalUser = true;
    description = "${settings.userDetails.username}";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = [
      # pkgs.home-manager
    ];
  };

  # users.groups.nixosvmtest = {};
  # users.users.nixosvmtest = {
  #   isSystemUser = true;
  #   initialPassword = "test";
  #   group = "nixosvmtest";
  # };

}