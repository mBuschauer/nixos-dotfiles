{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marco = {
    isNormalUser = true;
    description = "marco";
    extraGroups = [ "networkmanager" "wheel" "audio"  "storage" "docker"];
    packages = [
      pkgs.home-manager
    ];
  };

}
