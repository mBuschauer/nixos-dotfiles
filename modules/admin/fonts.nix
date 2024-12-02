{pkgs, ...}:
{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      font-awesome
      ibm-plex
      nerd-fonts.space-mono 
      nerd-fonts.jetbrains-mono
      nerd-fonts.dejavu-sans-mono
    ];
  };
  
  environment.sessionVariables = rec {
    # FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
    # FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
    FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
    FONTCONFIG_PATH = "/etc/fonts";
  };
  environment.systemPackages = with pkgs; [
    fontconfig
  ];
}
