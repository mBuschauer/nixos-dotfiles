{ config, pkgs, ... }: {
  # use new linux kernel

  boot = {
    # 6.13 is broken with nvidia beta drivers. Changed to 6.12 and it works.
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel = {
      # modify TCP buffer size
      sysctl."net.core.rmem_max" = 33554432;
      sysctl."net.core.wmem_max" = 33554432;
      # default                     4096	131072	6291456
      sysctl."net.ipv4.tcp_rmem" = "4096  87380   33554432";
      # default                     4096	16384	  4194304
      sysctl."net.ipv4.tcp_wmem" = "4096  65536   33554432";
    };

    plymouth.enable = true;
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --asterisks --cmd Hyprland";
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --asterisks";
        };
      };
    };
  };

}
