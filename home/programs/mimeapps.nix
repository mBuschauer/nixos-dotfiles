{ pkgs, ... }:
let
  browser = "firefox.desktop";
  images = "qimgv.desktop";
  fileExplorer = "org.kde.dolphin.deskop";
  # fileExplorer = "dolphin.desktop";
  fileArchiver = "corearchiver.desktop";
  vsCode = "codium.desktop";
in
{

  home.packages = with pkgs; [
    file
  ];


  xdg = {
    configFile."mimeapps.list".force = true;

    mimeApps = {
      enable = true;
      associations = {
        added = {
          "application/pdf" = [ "okular.desktop" ];
          "x-scheme-handler/http" = [ "${browser}" ];
          "x-scheme-handler/https" = [ "${browser}" ];
          "x-scheme-handler/chrome" = [ "${browser}" ];
          "text/html" = [ "${browser}" ];
          "application/x-extension-htm" = [ "${browser}" ];
          "application/x-extension-html" = [ "${browser}" ];
          "text/xhtml" = [ "${vsCode}" ];
          "application/x-extension-shtml" = [ "${browser}" ];
          "application/xhtml+xml" = [ "${browser}" ];
          "application/x-extension-xhtml" = [ "${browser}" ];
          "application/x-extension-xht" = [ "${browser}" ];
          "application/png" = [ "${images}" ];
          "application/xml" = [ "${vsCode}" ];

          "image/png" = [ "${images}" ];
          "image/jpg" = [ "${images}" ];
          "image/jpeg" = [ "${images}" ];
          "image/webp" = [ "${images}" ];
          "image/avif" = [ "${images}" ];

          "application/epub" = [ "sigil.desktop" ];
          "application/epub+zip" = [ "sigil.desktop" ];
          "text/plain" = [ "NotepadNext.desktop" ];
          "application/javascript" = [ "${vsCode}" ];

          "inode/directory" = [ "${fileExplorer}" ];
          "application/zip" = [ "${fileArchiver}" ];
          "application/cbr" = [ "${fileArchiver}" ]; # .cbr
          "application/vnd.comicbook-rar" = [ "${fileArchiver}" ]; # .cbr
          "application/cbz" = [ "okular.desktop" ]; # .cbz
          "application/vnd.comicbook+zip" = [ "okular.desktop" ]; # .cbz

          # set onlyoffice to open .docx, .pptx, .xlsx
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "onlyoffice-desktopeditors.desktop" ];
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "onlyoffice-desktopeditors.desktop" ];
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "onlyoffice-desktopeditors.desktop" ];

        };
        removed = {
          "application/epub" = [ "okular.desktop" ];
          "application/epub+zip" = [ "okular.desktop" ];
          "application/zip" = [ "prism.desktop" ];
          "application/cbr" = [ "okular.desktop" ];
          "application/vnd.comicbook-rar" = [ "okular.desktop" ];
          "application/pdf" = [ "calibre.desktop" ];
          "inode/directory" = [ "kitty-open.desktop" "nemo.desktop" ];
          "application/directory" = [ "prismlauncher.desktop" ];
          "text/plain" = [ "libreoffice.desktop" ];
          "image/png" = [ "chromium.desktop" ];
          "image/avif" = [ "okular.desktop" ];
          "text/html" = [ "calibre.desktop" ];
          "application/xml" = [ "chromium.desktop" ];
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "calibre.desktop" ];
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
        "application/javascript" = [ "${vsCode}" ];
        "inode/directory" = [ "${fileExplorer}" ];
        "application/zip" = [ "${fileArchiver}" ];
        "application/cbr" = [ "${fileArchiver}" ];
        "application/cbz" = [ "okular.desktop" ];
        "application/xml" = [ "${vsCode}" ];

        # set onlyoffice to open .docx, .pptx, .xlsx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "onlyoffice-desktopeditors.desktop" ];
      };
    };
  };

}
