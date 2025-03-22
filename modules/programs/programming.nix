{ config, pkgs, lib, inputs, settings, ... }:
{
  # enable docker
  users.users.${settings.userDetails.username}.extraGroups = [ "docker" ];
  virtualisation.docker = {
    enable = true;
    enableNvidia = if settings.customization.gpu == "nvidia" then true else false;
    liveRestore = false;
  };

  programs.bash = {
    completion = {
      enable = true;
      package = pkgs.bash-completion;
    };
  };

  services.ollama = {
    enable = false;
    package = pkgs.ollama;
    acceleration = "cuda";
    home = "/mnt/sda1/ollama";
    models = "${config.services.ollama.home}/models";
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
    # neovim
    lunarvim
    gedit

    rust-analyzer
    # pkg-config
    # openssl

    nil
    nixfmt-classic

    devenv
    # direnv

    # assorted dependencies
    gnat14

    godot_4

  ]
  ++ [
    # inputs.tsui.packages."x86_64-linux".tsui # currently broken, not going to fix now.
    # inputs.anyrun.packages."x86_64-linux".anyrun
  ];

}

