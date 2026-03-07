{ pkgs, lib, settings, ... }:
let
  browser = "firefox.desktop";
  # images = "org.gnome.gThumb.desktop";
  images = "qimgv.desktop";
  # fileExplorer = "org.kde.dolphin.deskop";
  fileExplorer = "nemo.desktop";
  fileArchiver = "corearchiver.desktop";
  # fileArchiver = "org.kde.ark.desktop";
  vsCode = "codium.desktop";
  videos = "mpv.desktop";
  okular = "org.kde.okular.desktop";
  notepad = "org.kde.kate.desktop";
in
{
  environment.systemPackages = with pkgs; [
    file
  ];
  home-manager.users.${settings.userDetails.username}.xdg = {
    configFile."mimeapps.list" = {
      enable = true;
      force = true;
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations = {
        added = {
          "application/pdf" = [ okular ];
          "x-scheme-handler/http" = [ browser ];
          "x-scheme-handler/https" = [ browser ];
          "x-scheme-handler/chrome" = [ browser ];
          "text/html" = [ browser ];
          "application/x-extension-htm" = [ browser ];
          "application/x-extension-html" = [ browser ];
          "text/xhtml" = [ vsCode ];
          "application/x-extension-shtml" = [ browser ];
          "application/xhtml+xml" = [ browser ];
          "application/x-extension-xhtml" = [ browser ];
          "application/x-extension-xht" = [ browser ];
          "application/png" = [ images ];
          "application/xml" = [ vsCode ];

          "image/png" = [ images ];
          "image/jpg" = [ images ];
          "image/jpeg" = [ images ];
          "image/webp" = [ images ];
          "image/avif" = [ images ];

          "video/x-matroska" = [ videos ];
          "video/mp4" = [ videos ];
          "video/quicktime" = [ videos ]; #.mov

          "application/epub" = [ "sigil.desktop" ];
          "application/epub+zip" = [ "sigil.desktop" ];
          "text/plain" = [ notepad ];
          "text/markdown" = [ notepad ];
          "application/javascript" = [ vsCode ];

          "inode/directory" = lib.mkForce [ fileExplorer ];
          "application/zip" = [ fileArchiver ];
          "application/cbr" = [ fileArchiver ]; # .cbr
          "application/vnd.comicbook-rar" = [ fileArchiver ]; # .cbr
          "application/cbz" = [ okular ]; # .cbz
          "application/vnd.comicbook+zip" = [ okular ]; # .cbz

          # set onlyoffice to open .docx, .pptx, .xlsx
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
            "onlyoffice-desktopeditors.desktop"
          ];
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
            "onlyoffice-desktopeditors.desktop"
          ];
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
            "onlyoffice-desktopeditors.desktop"
          ];

        };
        removed = {
          "application/epub" = [ okular ];
          "application/epub+zip" = [ okular ];
          "application/zip" = [ "prism.desktop" ];
          "application/cbr" = [ okular ];
          "application/vnd.comicbook-rar" = [ okular ];
          "application/pdf" = [
            "calibre.desktop"
            "brave-browser.desktop"
          ];
          "inode/directory" = lib.mkForce [
            "kitty-open.desktop"
            "nemo.desktop"
          ];
          "application/directory" = [ "prismlauncher.desktop" ];
          "text/plain" = [ "libreoffice.desktop" ];
          "text/markdown" = [ okular ];
          "image/png" = [ "chromium.desktop" ];
          "image/avif" = [ okular ];
          "text/html" = [ "calibre.desktop" ];
          "application/xml" = [ "chromium.desktop" ];
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "calibre.desktop" ];
          "video/quicktime" = [ "fr.handbrake.ghb.desktop" ];
        };
      };
      defaultApplications = {
        "application/pdf" = [ okular ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https" = [ browser ];
        "x-scheme-handler/chrome" = [ browser ];
        "text/html" = [ browser ];
        "text/xhtml" = [ browser ];
        "application/x-extension-htm" = [ browser ];
        "application/x-extension-html" = [ browser ];
        "application/x-extension-shtml" = [ browser ];
        "application/xhtml+xml" = [ browser ];
        "application/x-extension-xhtml" = [ browser ];
        "application/x-extension-xht" = [ browser ];
        "application/png" = [ images ];

        "image/png" = [ images ];
        "image/jpg" = [ images ];
        "image/jpeg" = [ images ];
        "image/webp" = [ images ];
        "image/avif" = [ images ];

        "video/x-matroska" = [ videos ];
        "video/mp4" = [ videos ];
        "video/quicktime" = [ videos ]; #.mov

        "application/epub" = [ "sigil.desktop" ];
        "application/epub+zip" = [ "sigil.desktop" ];
        "application/vnd.comicbook-rar" = [ fileArchiver ];
        "text/plain" = [ notepad ];
        "text/markdown" = [ notepad ];
        "application/javascript" = [ vsCode ];
        "inode/directory" = lib.mkForce [ fileExplorer ];
        "application/zip" = [ fileArchiver ];
        "application/cbr" = [ fileArchiver ];
        "application/cbz" = [ okular ];
        "application/xml" = [ vsCode ];

        # set onlyoffice to open .docx, .pptx, .xlsx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
          "onlyoffice-desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
          "onlyoffice-desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
          "onlyoffice-desktopeditors.desktop"
        ];
      };
    };
  };

}
