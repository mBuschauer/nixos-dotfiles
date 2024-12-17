{ settings, ... }:
let
  matchHostname = hostname:
    if hostname == "nixos" then ./home.nix
    else if hostname == "MarcoMNix" then ./school.nix
    else throw "Unsupported Host";
in
{
  import = matchHostname settings.customization.hostname;
}
