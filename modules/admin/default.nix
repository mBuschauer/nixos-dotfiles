{ settings, ... }:
let
  matchBool = enable:
    if enable then ./boot/secureboot.nix else ./boot/systemd-boot.nix;
in {
  imports = [
    ./boot.nix
    ./clamav.nix
    ./fonts.nix
    ./settings.nix
    # ./sudo.nix
    ./users.nix
    (matchBool settings.customization.enable_secureboot)
  ];
}
