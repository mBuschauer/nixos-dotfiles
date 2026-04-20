{
  config,
  pkgs,
  lib,
  inputs,
  settings,
  ...
}:
{
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

  environment.systemPackages =
    with pkgs;
    [
      zoom-us

      onlyoffice-desktopeditors
      # libreoffice-fresh
      hunspell
      hunspellDicts.en_US

      kdePackages.okular

      kdePackages.kate

      teams-for-linux # electron client for microsoft teams
      # joplin-desktop
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

      wl-clipboard
      fastfetch

      # fun cli programs
      cava
      toipe
      lolcat
      asciiquarium
      sl
      peaclock
      cmatrix

      ncspot
      ncdu
      ncmpcpp
      mpc
      dconf # idk why this is needed now
      imagemagick
      mpg123
      stable.calibre

      # spotify
      qalculate-gtk
      qimgv # image viewer
      gthumb # image viewer
      kdePackages.ark # zip browser
      CuboCore.corearchiver # zip browser
      # localsend

      # caligula # disk/iso imager

      handbrake
      mkvtoolnix

      # gimp # gimp

      # ventoy # to create bootable drives

      xhost
      kdePackages.partitionmanager # alternative to disks
      parted
      gparted
      tparted

      # hakuneko

      p7zip # for 7z support

      discord
      # webcord # a different discord client
      # vesktop # discord electron wrapper, hardware acceleration doesnt seem to work though

      stable.slack

      kdePackages.kclock # alarm app
      # gnome-clocks # clock app

      cmd-wrapped

      lshw-gui

      audacity

      # whatsapp-for-linux

      feishin # subsonic player (desktop client)

      fzf

      nemo

      glib
      gsettings-desktop-schemas
      dconf-editor

      hyprsysteminfo

      cheese

      wineWow64Packages.full
      # wineWow64Packages.wayland
      winetricks

      pandoc
      pv
      poppler-utils
    ]
    ++ [
      # inputs.hyprsysteminfo.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.hyprpwcenter.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs.obs-studio = {
    # enable = true;
    enable = false;
    package = pkgs.obs-studio;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      wlrobs
      obs-vaapi
    ];

  };

  home-manager.users.${settings.userDetails.username} = {
    services.tailray = {
      enable = true;
      theme = "dark";
    };

    programs.ncspot = {
      enable = false;

      settings = {
        use_nerdfont = true;
        volnorm = true;
      };
    };

    programs.lazyvim = {
      enable = true;

      extras = {
        lang.nix.enable = true;
        lang.python = {
          enable = true;
          installDependencies = true; # Install ruff
          installRuntimeDependencies = true; # Install python3
        };
        lang.docker.enable = true;
        lang.rust.enable = true;
        lang.toml.enable = true;
        lang.docker-compose.enable = true;
      };

      # Additional packages (optional)
      extraPackages = with pkgs; [
        nixd # Nix LSP
        alejandra # Nix formatter
      ];

    };

    xdg.desktopEntries = {
      # hakunektwo = {
      #   name = "Hakunektwo";
      #   exec = "hakuneko --no-sandbox";
      #   terminal = false;
      #   icon = "${pkgs.hakuneko}/share/icons/hicolor/256x256/apps/hakuneko-desktop.png";
      # };

      tailscale-tray = {
        name = "Tailscale SysTray";
        exec = "env TAILRAY_THEME=dark tailray";
        terminal = false;
        icon = "${
          inputs.tailray.packages.${pkgs.stdenv.hostPlatform.system}.tailray
        }/share/icons/hicolor/symbolic/apps/tailscale-online.svg";
      };

      # notepad = {
      #   name = "Notepad";
      #   comment = "Edit text files";
      #   exec = "env GTK_THEME=Adwaita:light gedit %U";
      #   terminal = false;
      #   type = "Application";
      #   startupNotify = true;
      #   mimeType = [
      #     "text/plain"
      #     "application/x-zerosize"
      #   ];
      #   icon = "notepadqq";
      # };

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
        # icon = "${pkgs.nemo}/share/icons/hicolor/32x32/apps/nemo.png";
        icon = "nemo";
        startupNotify = false;
        type = "Application";
      };

      # jellyfin = {
      #   name = "Jellyfin Media Player (qt6)";
      #   exec = "hyprctl dispatch exec jellyfinmediaplayer";
      #   comment = "Desktop client for Jellyfin";
      #   terminal = false;
      #   icon = "com.github.iwalton3.jellyfin-media-player";
      #   startupNotify = false;
      #   type = "Application";
      #   categories = ["AudioVideo" "Video" "Player" "TV"];

      # };

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
        icon = "${pkgs.CuboCore.corearchiver}/share/icons/hicolor/scalable/apps/cc.cubocore.CoreArchiver.svg";
        terminal = false;
        startupNotify = true;
        categories = [
          "Qt"
          "Utility"
          "FileTools"
          "Archiving"
          "Compression"
          "X-CSuite"
        ];
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

      whatsapp-web = {
        name = "Whatsapp Web";
        exec = "xdg-open https://web.whatsapp.com/";
        terminal = false;
        icon = "whatsapp-for-linux";
        startupNotify = false;
        type = "Application";
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
  };

}
