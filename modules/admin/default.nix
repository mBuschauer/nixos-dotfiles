{ ... }:
{
  imports =
    [
      ./boot.nix
      ./clamav.nix
      ./fonts.nix
      ./settings.nix
      # ./sudo.nix
      ./users.nix
    ];
}
