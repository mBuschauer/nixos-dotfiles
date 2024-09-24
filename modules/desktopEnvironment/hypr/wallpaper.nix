{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.swww.packages.${pkgs.system}.swww
    waypaper
  ];

}