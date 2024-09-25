{ ... }:
{
  imports = [
    # desktop environments
    ./desktopEnvironment/hypr
    ./desktopEnvironment/anyrun
    # ./desktopEnvironment/gnome.nix

    # all programs, etc
    ./programs

    ./hardware

    ./home.nix
  ];
}
