{ settings, ... }:
{
  imports = [
    # all programs, etc
    ./programs

    ./hardware

    ./home.nix

    ./desktopEnvironment/hypr
    # ./desktopEnvironment/gnome.nix
    # ./desktopEnvironment/kde.nix
    # ./desktopEnvironment/cosmic.nix
  ];
}
