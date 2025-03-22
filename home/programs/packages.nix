{ inputs, pkgs, ... }:
{

  home.packages = with pkgs; [
    wl-clipboard
    fastfetch

    # fun cli programs
    stable.cava

    toipe
    lolcat
    asciiquarium
    sl
    peaclock
    cmatrix

    ncspot
    ncdu
    ncmpcpp
    mpc-cli
    dconf # idk why this is needed now
    imagemagick
    mpg123
    calibre

    spotify
    prismlauncher
    qalculate-gtk
    qimgv # image viewer
    # pqiv # image viewer
    # kdePackages.ark # zip browser
    CuboCore.corearchiver # zip browser
    rofi-wayland
    # localsend


    # caligula # disk/iso imager

    handbrake
    mkvtoolnix

    gimp # gimp

    ventoy # to create bootable drives
    gparted # alternative to disks

    hakuneko

    p7zip # for 7z support

    discord
    # webcord # a different discord client
    # vesktop # discord electron wrapper, hardware acceleration doesnt seem to work though

    kdePackages.kclock # alarm app
    # gnome-clocks # clock app

    cmd-wrapped

    lunarvim

    lshw-gui

    audacity

    # whatsapp-for-linux

  ] ++ [
    inputs.hyprsysteminfo.packages."x86_64-linux".hyprsysteminfo
  ];

  imports = [
    inputs.tailray.homeManagerModules.default
  ];

  services.tailray.enable = true;


  programs.ncspot = {
    enable = true;

    settings = {
      use_nerdfont = true;
      volnorm = true;
    };
  };

  xdg.desktopEntries = {
    hakunektwo = {
      name = "Hakunektwo";
      exec = "hakuneko --no-sandbox";
      terminal = false;
      icon = "${pkgs.hakuneko}/share/icons/hicolor/256x256/apps/hakuneko-desktop.png";
    };

    tailscale-tray = {
      name = "Tailscale SysTray";
      exec = "tailray";
      terminal = false;
      icon = "${inputs.tailray.packages.${pkgs.system}.tailray}/share/icons/hicolor/symbolic/apps/tailscale-online.svg";
    };

    lshw-gui = {
      name = "lshw-gui";
      exec = "gtk-lshw";
      terminal = false;
    };


    # discord-webcord = {
    #   name = "Discord";
    #   exec = "webcord";
    #   terminal = false;
    #   icon = "${pkgs.webcord}/share/icons/hicolor/256x256/apps/webcord.png";
    # };

    nemo = {
      name = "nemo";
      exec = "nemo %U";
      terminal = false;
      icon = "${pkgs.nemo}/share/icons/hicolor/32x32/apps/nemo.png";
      startupNotify = false;
      type = "Application";
    };

    # hyprsysteminfo = {
    #   name = "HyprSystemInfo";
    #   exec = "hyprsysteminfo";
    #   terminal = false;
    # };
    corearchiver = {
      type = "Application";
      name = "CoreArchiver";
      comment = "Archiver for C Suite, to create and extract archives.";
      exec = "corearchiver %F";
      icon = "${pkgs.CuboCore.corearchiver}/share/icons/hicolor/scalable/apps/org.cubocore.CoreArchiver.svg";
      terminal = false;
      startupNotify = true;
      categories = [ "Qt" "Utility" "FileTools" "Archiving" "Compression" "X-CSuite" ];
      mimeType = [
        "application/x-cpio"
        "application/x-shar"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/octet-stream"
        "application/x-xz-compressed-tar"
        "application/x-lzma-compressed-tar"
        "application/x-lz4-compressed-tar"
        "application/x-bzip-compressed-tar"
        "application/x-tarz"
        "application/x-cd-image"
        "application/zip"
        "application/x-archive"
        "application/x-xar"
        "application/x-7z-compressed"
        "application/x-lzip"
        "application/x-lz4"
        "text/x-uuencode"
        "application/x-lzop"
        "application/gzip"
        "application/x-bzip"
        "application/x-lzma"
        "application/x-xz"
        "application/x-lrzip"
      ];
      actions = {
        CreateArchive = {
          name = "Add to archive";
          exec = "corearchiver %F";
        };
        ExtractArchive = {
          name = "Extract archive";
          exec = "corearchiver %F";
        };
      };
    };

  };

  programs.lsd = {
    enable = true;
    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      color = {
        when = "never";
        theme = "default";
      };
      date = "date";
      dereference = false;
      icons = {
        when = "auto";
        theme = "fancy";
        seperator = " ";
      };
      indicators = false;
      layout = "tree";
      recursion = {
        enabled = false;
        depth = 1;
      };
      size = "default";
      permission = "rwx";
      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "first";
      };
      no-symlink = false;
      hyperlink = "never";
      symlink-arrow = "⇒";
      header = false;
    };
  };


  programs.tofi = {
    enable = false;
    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 8;
      font = "monospace";
      font-size = 14;
      background-color = "#000A";
      history = true;
    };
  };
  
}
