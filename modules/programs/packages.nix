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

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    zoom-us

    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US

    kdePackages.okular

    notepad-next

    teams-for-linux # electron client for microsoft teams
    joplin-desktop
    mpv

    # komikku

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

    fd
    ripgrep

    obsidian
    fstl
    # phoronix-test-suite

    jellyfin-media-player
    sigil

    mission-center
    bottom
    btop

    # part of v4l2loopback
    v4l-utils

  ];

  # Activate kernel modules for OBS virtual camera
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

}
