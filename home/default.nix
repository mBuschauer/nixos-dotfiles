{ settings, ... }:
{
  imports = [
    # all programs, etc
    ./programs

    ./hardware

    ./home.nix

    ./themes.nix

    ./desktopEnvironment
    # ./desktopEnvironment/gnome.nix
    # ./desktopEnvironment/kde.nix
    # ./desktopEnvironment/cosmic.nix
  ];
}
