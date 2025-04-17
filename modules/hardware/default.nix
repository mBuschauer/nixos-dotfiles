{ ... }:
{
  imports =
    [
      ./audio.nix
      ./bluetooth.nix
      ./hardware.nix
      ./network.nix
      ./printers.nix
      # ./security.nix

      ./gpu
      ./drives

    ];
}
