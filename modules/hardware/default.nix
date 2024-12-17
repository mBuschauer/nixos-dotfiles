{ ... }:
{
  imports =
    [
      ./audio.nix
      ./bluetooth.nix
      ./hardware.nix
      ./network.nix
      ./printers.nix

      ./gpu
      ./drives

    ];
}
