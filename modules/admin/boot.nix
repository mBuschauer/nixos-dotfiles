{ config, pkgs, ... }:
{
  # use new linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_9;
  
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
