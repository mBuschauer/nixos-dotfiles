{ config, pkgs, lib, ... }:
let
  # this is related to an issue with nvidia, I believe, not wayland but setting backend as xcb seems to fix playback issues
  jellyfin-wayland = pkgs.jellyfin-media-player.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/jellyfinmediaplayer --set QT_QPA_PLATFORM xcb 
    '';
  });
  # seemed to have trouble rendering on wayland w/ nvidia gpu, setting backend as xcb seems to fix them
  sigil-wayland = pkgs.sigil.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/sigil --set QT_QPA_PLATFORM xcb 
    '';
  });

  # for firefox config
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };

in
{
  nixpkgs.config.allowUnfree = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    wrapperConfig = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisplayBookmarksToolbar = "always";

      ExtensionSettings = {
        # privacy badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # ghostery
        "firefox@ghostery.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ghostery/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # sponsorblock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        # Alpenglow Dark (theme)
        "{9b615f11-c3a3-46bd-97a8-1721bb8122b9}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/alpenglow-dark/latest.xpi";
          installation_mode = "force_installed";
        };
        # Always active Window - Always Visible
        "{4b7825da-0dd1-44f9-9717-bee5b2408af6}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/always-visible/latest.xpi";
          installation_mode = "normal_installed";
        };
        # wikiwand
        "jid1-D7momAzRw417Ag@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/wikiwand-wikipedia-modernized/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
      Preferences = {
        "extensions.pocket.enabled" = lock-false;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };


  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };

  programs.thunar = {
    enable = false;
    plugins = with pkgs.xfce; [
      thunar-volman
    ];
  };

  programs.tmux.enable = true;


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
    discord
    # vesktop # discord electron wrapper, hardware acceleration doesnt seem to work though

    libreoffice-fresh
    libsForQt5.okular

    ## Task Manager for Linux
    # monitor
    # gnome.gnome-system-monitor
    # kdePackages.plasma-systemmonitor
    mission-center

    notepad-next

    teams-for-linux # electron client for microsoft teams

    mpv

    komikku

    sigil-wayland # override because its broken on Nvidia
    jellyfin-wayland # override because its broken on Nvidia

    ryujinx

    zip
    unzip

    wget
    bottom
    bat

    nitch # mini neofetch

    trashy # useful for trashing things without rm -rf

    yazi # terminal file browser

    webcamoid
  ];
}
