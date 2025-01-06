{ settings, ... }:
let
  matchString = gpu:
    if gpu == "amd" then ./gpu/amd.nix
    else if gpu == "nvidia" then ./gpu/nvidia.nix
    else throw "Unsupported GPU type: ${gpu}";
in
{
  imports =
    [
      ./waybar.nix
      (matchString settings.customization.gpu)
    ];
}
