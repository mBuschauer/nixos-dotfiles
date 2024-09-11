{ ... }:
{
  imports = [
    ./env.nix

    # desktop environments
    ./desktopEnvironment/hypr
    # ./desktopEnvironment/gnome.nix

    # all programs, etc
    ./programs

    ./hardware

    ./home.nix
  ];
}
