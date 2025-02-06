{ pkgs, ... }: {
  services.desktopManager.cosmic.enable = true;

  # all for installing Cosmic Desktop Alpha 4
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys =
      [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

}
