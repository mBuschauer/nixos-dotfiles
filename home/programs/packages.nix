{ inputs, pkgs, ... }:
{

  home.packages = with pkgs; [
    wl-clipboard
    fastfetch
    cava
    toipe
    ncspot
    ncdu
    ncmpcpp
    mpc-cli
    dconf # idk why this is needed now
    lolcat
    asciiquarium
    imagemagick
    mpg123
    peaclock
    lazygit
    calibre
    sl
    cmatrix
    #spotify      
    prismlauncher
    #mangohud
    qalculate-gtk
    qimgv # image viewer
    libsForQt5.ark # zip browser
    rofi-wayland

    heroic
    # localsend

    # caligula # disk/iso imager

    handbrake
    mkvtoolnix

    gimp # gimp

    ventoy # to create bootable drives
    gparted # alternative to disks

    hakuneko
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
      icon = "${inputs.tailray.packages.${pkgs.system}.tailray}/icons/tailscale-offline.svg"; # doesnt work, idk why, idc
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
