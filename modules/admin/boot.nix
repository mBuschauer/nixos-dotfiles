{ config, pkgs, ... }:
{
  # use new linux kernel

  # 6.11 is broken with nvidia stable drivers. Changed to beta and it works.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # modify TCP buffer size
  boot.kernel.sysctl."net.core.rmem_max" = 33554432;
  boot.kernel.sysctl."net.core.wmem_max" = 33554432;
  # default                                 4096	131072	6291456
  boot.kernel.sysctl."net.ipv4.tcp_rmem" = "4096  87380   33554432";
  # default                                 4096	16384	  4194304
  boot.kernel.sysctl."net.ipv4.tcp_wmem" = "4096  65536   33554432";


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
