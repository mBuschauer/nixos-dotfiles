{ settings, ... }:
{
  imports = [
    ./firefox.nix
    ./games.nix
    ./packages.nix
    ./programming
    ./gpu

    ./chrome.nix
    ./mimeapps.nix

  ];
}
