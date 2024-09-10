{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    associations = {
      added = {
        "application/pdf" = ["okular.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/chrome" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "application/x-extension-htm" = ["firefox.desktop"];
        "application/x-extension-html" = ["firefox.desktop"];
        "text/xhtml" = ["code.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop"];
        "application/xhtml+xml" = ["firefox.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop"];
        "application/x-extension-xht" = ["firefox.desktop"];
        "application/png" = ["qimgv.desktop"];
        "application/xml" = ["code.desktop"];
        
        "image/png" = ["qimgv.desktop"];
        "image/jpg" = ["qimgv.desktop"];
        "image/jpeg" = ["qimgv.desktop"];
        "image/webp" = ["qimgv.desktop"];
        "image/avif" = ["qimgv.desktop"];

        "application/epub" = ["sigil.desktop"];
        "application/epub+zip" = ["sigil.desktop"];
        "text/plain" = ["NotepadNext.desktop"];
        "inode/directory" = ["nemo.deskop"];
        "application/zip" = ["ark.desktop"];
        "application/cbr" = ["ark.desktop"]; # .cbr
        "application/vnd.comicbook-rar" = ["ark.desktop"]; # .cbr
        "application/cbz" = ["okular.desktop"]; # .cbz
        "application/vnd.comicbook+zip" = [ "okular.desktop" ]; # .cbz
     };
      removed = {
        "application/epub" = ["okular.desktop"];
        "application/epub+zip" = ["okular.desktop"];
        "application/cbr" = ["okular.desktop"];
        "application/vnd.comicbook-rar" = ["okular.desktop"];
        "application/pdf" = ["calibre.desktop"];
        "inode/directory" = ["code.desktop" "zed.desktop"];
        "application/directory" = ["prismlauncher.desktop"];
        "text/plain" = ["libreoffice.desktop"];
        "image/png" = ["chromium.desktop"];
        "image/avif" = ["okular.desktop"];
        "text/html" = ["calibre.desktop"];
        "application/xml" = ["chromium.desktop"];
      };
    };
    defaultApplications = {
      "application/pdf" = ["okular.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "text/xhtml" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
      "application/png" = ["qimgv.desktop"];
      
      "image/png" = ["qimgv.desktop"];
      "image/jpg" = ["qimgv.desktop"];
      "image/jpeg" = ["qimgv.desktop"];
      "image/webp" = ["qimgv.desktop"];
      "image/avif" = ["qimgv.desktop"];

      "application/epub" = ["sigil.desktop"];
      "application/epub+zip" = ["sigil.desktop"];
      "application/vnd.comicbook-rar" = ["ark.desktop"];
      "text/plain" = ["NotepadNext.desktop"];
      "inode/directory" = ["nemo.desktop"]; # not working??
      "application/zip" = ["ark.desktop"];
      "application/cbr" = ["ark.desktop"];
      "application/cbz" = ["okular.desktop"];
      "application/xml" = ["code.desktop"];
    };
  };

}
