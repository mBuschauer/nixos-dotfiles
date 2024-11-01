{ config, pkgs, ... }:
{
  # use new linux kernel

  # 6.11 is broken with nvidia stable drivers. Changed to beta and not works.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    # "initcall_blacklist=simpledrm_platform_driver_init"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --asterisks --cmd Hyprland";
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --asterisks";
        };
      };
    };
  };

}
