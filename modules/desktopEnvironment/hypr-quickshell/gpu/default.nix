{ settings, ... }:
let
  matchString = gpu:
    if gpu == "amd" then ./amd.nix
    else if gpu == "nvidia" then ./nvidia.nix
    else throw "Unsupported GPU type: ${gpu}";
in
{
  imports =
    [
      (matchString settings.customization.gpu)
    ];
}
