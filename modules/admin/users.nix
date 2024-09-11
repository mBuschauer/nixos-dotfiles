{ pkgs, settings, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.username} = {
    isNormalUser = true;
    description = "${settings.username}";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = [
      # pkgs.home-manager
    ];
  };

}