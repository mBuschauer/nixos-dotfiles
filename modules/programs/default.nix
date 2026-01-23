{ settings, ... }:
{
  imports = [
    ./firefox.nix
    ./games.nix
    ./packages.nix
    ./programming.nix
    ./gpu

    ./chrome.nix
    ./mimeapps.nix

  ];
}
