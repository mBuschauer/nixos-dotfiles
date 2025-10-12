{ config, pkgs, ... }: {
  # use new linux kernel

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # kernel = {
    #   # modify TCP buffer size
    #   sysctl."net.core.rmem_max" = 33554432;
    #   sysctl."net.core.wmem_max" = 33554432;
    #   # default                     4096	131072	6291456
    #   sysctl."net.ipv4.tcp_rmem" = "4096  87380   33554432";
    #   # default                     4096	16384	  4194304
    #   sysctl."net.ipv4.tcp_wmem" = "4096  65536   33554432";
    # };

    # plymouth.enable = true; 
  };

  nix = {
    extraOptions = ''
      download-buffer-size = 134217728 
    '';
  };


  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time -r --asterisks --cmd Hyprland";
        # command = "${pkgs.tuigreet}/bin/tuigreet --time -r --asterisks";
      };
    };
  };

}
