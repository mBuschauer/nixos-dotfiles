{ ... }:
{
  imports =
    [
      ./audio.nix
      ./bluetooth.nix
      ./hardware.nix
      ./network
      ./printers.nix
      # ./security.nix

      ./gpu
      ./drives

    ];
}
