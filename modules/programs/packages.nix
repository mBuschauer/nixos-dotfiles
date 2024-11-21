{ config, pkgs, lib, inputs, ... }:
let
  # this is related to an issue with nvidia, I believe, not wayland but setting backend as xcb seems to fix playback issues
  jellyfin-wayland = pkgs.jellyfin-media-player.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/jellyfinmediaplayer --set QT_QPA_PLATFORM xcb 
    '';
  });
  # seemed to have trouble rendering on wayland w/ nvidia gpu, setting backend as xcb seems to fix them
  sigil-wayland = pkgs.sigil.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/sigil --set QT_QPA_PLATFORM xcb 
    '';
  });

in
{
  nixpkgs.config.allowUnfree = true;

  programs.thunar = {
    enable = false;
    plugins = with pkgs.xfce; [
      thunar-volman
    ];
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

    stable.libreoffice-fresh
    libsForQt5.okular

    ## Task Manager for Linux
    # monitor
    # gnome.gnome-system-monitor
    # kdePackages.plasma-systemmonitor
    stable.mission-center

    notepad-next

    teams-for-linux # electron client for microsoft teams

    mpv

    komikku

    sigil-wayland # override because its broken on Nvidia
    jellyfin-wayland # override because its broken on Nvidia

    ryujinx

    zip
    unzip
    gzip

    wget
    bottom
    bat

    nitch # mini neofetch

    trashy # useful for trashing things without rm -rf

    yazi # terminal file browser

    webcamoid
  ];
}
