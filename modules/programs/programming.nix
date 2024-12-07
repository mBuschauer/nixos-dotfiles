{ config, pkgs, lib, inputs, settings, ... }:
let
  neovim = pkgs.neovim.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/share/applications/nvim.desktop \
        --replace "TryExec=nvim" "" \
        --replace "Terminal=true" "Terminal=false" \
        --replace "Exec=nvim %F" "Exec=kitty -e nvim %F"
    '';
  });
in
{
  # enable docker
  users.users.${settings.username}.extraGroups = [ "docker" ];
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };

  # for creating gpg keys
  services.pcscd.enable = true;
  programs.gnupg = {
    package = pkgs.gnupg;
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.X11Forwarding = true;
    extraConfig = ''
      X11UseLocalHost no
    '';
  };

  programs.ssh = {
    package = pkgs.openssh;
    forwardX11 = true;
  };

  programs.tmux.enable = true;



  environment.systemPackages = with pkgs; [
    rustc
    rustup
    cargo

    python311

    jdk21
    jdk17
    jdk8
    #lua
    #zig
    sqlite

    docker-compose

    vim
    neovim
    lunarvim
    gedit

    rust-analyzer
    # pkg-config
    # openssl

    nil
    nixpkgs-fmt

    devenv
    # direnv

    # assorted dependencies
    gnat14

  ]
  ++ [
    # inputs.tsui.packages."x86_64-linux".tsui # currently broken, not going to fix now.
    # inputs.anyrun.packages."x86_64-linux".anyrun
  ];

}

