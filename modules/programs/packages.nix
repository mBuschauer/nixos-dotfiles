{ config, pkgs, lib, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.thunar = {
    enable = false;
    plugins = with pkgs.xfce; [ thunar-volman ];
  };

  #services.onedrive = {
  #  enable = true;
  #  package = pkgs.onedrive;
  #};

  #services.cron = {
  #  enable = true;
  #  systemCronJobs = [
  #    "*/10 * * * *      marco    onedrive --single-directory \"Maryland\" --dry-run --sync" # every 10 minutes, sync the Maryland dir in Onedrive
  #  ];
  #};

  environment.systemPackages = with pkgs; [
    zoom-us

    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US

    libsForQt5.okular

    notepad-next

    teams-for-linux # electron client for microsoft teams

    mpv

    komikku

    zip
    unzip
    gzip
    unar # not unrar

    wget
    bat

    nitch # mini neofetch

    trashy # useful for trashing things without rm -rf

    yazi # terminal file browser

    webcamoid
    busybox

    stable.texliveFull # for editing latex
  ];
}
