{ pkgs, settings, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      font-awesome
      ibm-plex
      corefonts
      vistafonts
      fira-code
      dejavu_fonts

      nerd-fonts.space-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.dejavu-sans-mono
    ];
  };

  system.activationScripts = {
    movefonts.text =
      ''
        mkdir -p /home/${settings.userDetails.username}/.local/share/fonts
        rm /home/${settings.userDetails.username}/.local/share/fonts/*
        cp ${pkgs.corefonts}/share/fonts/truetype/*.ttf /home/${settings.userDetails.username}/.local/share/fonts/
        cp ${pkgs.vistafonts}/share/fonts/truetype/*.ttf /home/${settings.userDetails.username}/.local/share/fonts/
        cp ${pkgs.dejavu_fonts}/share/fonts/truetype/*.ttf /home/${settings.userDetails.username}/.local/share/fonts/
        chmod 644 /home/${settings.userDetails.username}/.local/share/fonts/*
      '';
  };

  environment.sessionVariables = rec {
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
    FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
    # FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
    # FONTCONFIG_PATH = "/etc/fonts";
  };
  environment.systemPackages = with pkgs; [
    fontconfig
  ];
}
