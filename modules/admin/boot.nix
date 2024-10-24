{ config, pkgs, ... }:
{
  # use new linux kernel

  # 6.11 is broken in nixpkgs. Pinning it at 6.10 for now.
  # boot.kernelPackages = pkgs.linuxPackages_latest; 
  # https://github.com/NixOS/nixpkgs/issues/343774
  # https://github.com/NVIDIA/open-gpu-kernel-modules/pull/692
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_10;

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
