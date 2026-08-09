{ inputs, pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
    configs = {
      default = ./config;
    };
    activeConfig = "default";
  };
}
