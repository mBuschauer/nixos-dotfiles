{ config, pkgs, ... }:
{
  # use new linux kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest; # having issues with 6.11
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_10;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --asterisks --cmd Hyprland";
        };
      };
    };
  };

}
