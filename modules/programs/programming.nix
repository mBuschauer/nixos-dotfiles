{ config, pkgs, lib, inputs, settings, ... }:
let
  ollamaGPU = if settings.customization.gpu == "nvidia" then
    pkgs.ollama-cuda
  else if settings.customization.gpu == "amd" then
    pkgs.ollama-rocm
  else
    pkgs.ollama;

in {

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys =
      [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  # enable docker
  users.users.${settings.userDetails.username}.extraGroups = [ "docker" ];
  virtualisation.docker = {
    enable = true;
    # enableNvidia = if settings.customization.gpu == "nvidia" then true else false;
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
    package = ollamaGPU;
    home = "/mnt/sda1/ollama";
    models =
      "${config.services.ollama.home}/models"; # references home (/mnt/sda1/ollama/models)
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

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [ icu openssl zlib ];

  environment.systemPackages = with pkgs;
    [
      rustc
      rustup
      cargo

      python313

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

      tio # screen/minicom alternative
      lazygit

      # unityhub

      # fpga stuff
      iverilog
      gtkwave
      apio

    ] ++ [
      # inputs.tsui.packages."x86_64-linux".tsui # currently broken, not going to fix now.
    ];
  services.udev.packages = with pkgs;
    [ apio-udev-rules ]; # for FPGA work  (ftdi)
}

