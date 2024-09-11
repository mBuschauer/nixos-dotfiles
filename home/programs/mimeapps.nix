{ ... }:
let
  browser = "firefox.desktop";
  images = "qimgv.desktop";
  fileExplorer = "org.kde.dolphin.deskop";
  fileArchiver = "ark.desktop";
in
{
  xdg.mimeApps = {
    enable = true;
    associations = {
      added = {
        "application/pdf" = [ "${browser}" ];
        "x-scheme-handler/http" = [ "${browser}" ];
        "x-scheme-handler/https" = [ "${browser}" ];
        "x-scheme-handler/chrome" = [ "${browser}" ];
        "text/html" = [ "${browser}" ];
        "application/x-extension-htm" = [ "${browser}" ];
        "application/x-extension-html" = [ "${browser}" ];
        "text/xhtml" = [ "code.desktop" ];
        "application/x-extension-shtml" = [ "${browser}" ];
        "application/xhtml+xml" = [ "${browser}" ];
        "application/x-extension-xhtml" = [ "${browser}" ];
        "application/x-extension-xht" = [ "${browser}" ];
        "application/png" = [ "${images}" ];
        "application/xml" = [ "code.desktop" ];

        "image/png" = [ "${images}" ];
        "image/jpg" = [ "${images}" ];
        "image/jpeg" = [ "${images}" ];
        "image/webp" = [ "${images}" ];
        "image/avif" = [ "${images}" ];

        "application/epub" = [ "sigil.desktop" ];
        "application/epub+zip" = [ "sigil.desktop" ];
        "text/plain" = [ "NotepadNext.desktop" ];
        "inode/directory" = [ "${fileExplorer}" ];
        "application/zip" = [ "${fileArchiver}" ];
        "application/cbr" = [ "${fileArchiver}" ]; # .cbr
        "application/vnd.comicbook-rar" = [ "${fileArchiver}" ]; # .cbr
        "application/cbz" = [ "okular.desktop" ]; # .cbz
        "application/vnd.comicbook+zip" = [ "okular.desktop" ]; # .cbz
      };
      removed = {
        "application/epub" = [ "okular.desktop" ];
        "application/epub+zip" = [ "okular.desktop" ];
        "application/cbr" = [ "okular.desktop" ];
        "application/vnd.comicbook-rar" = [ "okular.desktop" ];
        "application/pdf" = [ "calibre.desktop" ];
        "inode/directory" = [ "code.desktop" "zed.desktop" ];
        "application/directory" = [ "prismlauncher.desktop" ];
        "text/plain" = [ "libreoffice.desktop" ];
        "image/png" = [ "chromium.desktop" ];
        "image/avif" = [ "okular.desktop" ];
        "text/html" = [ "calibre.desktop" ];
        "application/xml" = [ "chromium.desktop" ];
      };
    };
    defaultApplications = {
      "application/pdf" = [ "okular.desktop" ];
      "x-scheme-handler/http" = [ "${browser}" ];
      "x-scheme-handler/https" = [ "${browser}" ];
      "x-scheme-handler/chrome" = [ "${browser}" ];
      "text/html" = [ "${browser}" ];
      "text/xhtml" = [ "${browser}" ];
      "application/x-extension-htm" = [ "${browser}" ];
      "application/x-extension-html" = [ "${browser}" ];
      "application/x-extension-shtml" = [ "${browser}" ];
      "application/xhtml+xml" = [ "${browser}" ];
      "application/x-extension-xhtml" = [ "${browser}" ];
      "application/x-extension-xht" = [ "${browser}" ];
      "application/png" = [ "${images}" ];

      "image/png" = [ "${images}" ];
      "image/jpg" = [ "${images}" ];
      "image/jpeg" = [ "${images}" ];
      "image/webp" = [ "${images}" ];
      "image/avif" = [ "${images}" ];

      "application/epub" = [ "sigil.desktop" ];
      "application/epub+zip" = [ "sigil.desktop" ];
      "application/vnd.comicbook-rar" = [ "${fileArchiver}" ];
      "text/plain" = [ "NotepadNext.desktop" ];
      "inode/directory" = [ "${fileExplorer}" ];
      "application/zip" = [ "${fileArchiver}" ];
      "application/cbr" = [ "${fileArchiver}" ];
      "application/cbz" = [ "okular.desktop" ];
      "application/xml" = [ "code.desktop" ];
    };
  };

}
