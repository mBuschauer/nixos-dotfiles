{ config, pkgs, lib, inputs, ... }:
let
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
      DisplayBookmarksToolbar = true;

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
}
