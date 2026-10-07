{
  config,
  pkgs,
  lib,
  inputs,
  settings,
  secrets,
  ...
}:
let
  ollamaGPU =
    if settings.customization.gpu == "nvidia" then
      pkgs.ollama-cuda
    else if settings.customization.gpu == "amd" then
      pkgs.ollama-rocm
    else
      pkgs.ollama;

in
{

  programs.bash = {
    completion = {
      enable = true;
      package = pkgs.bash-completion;
    };
  };

  services.ollama = {
    enable = false;
    package = ollamaGPU;
    # home = "/mnt/sda1/ollama";
    # modelsDir = "${config.services.ollama.home}/models"; # references home (/mnt/sda1/ollama/models)
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

  environment.systemPackages = with pkgs; [
    stable.rustc
    stable.rustup
    stable.cargo

    python313

    jdk21
    jdk17
    jdk8
    #lua
    #zig
    sqlite

    vim
    # neovim
    gedit

    rust-analyzer
    # pkg-config
    # openssl

    nil
    nixd
    nixfmt

    devenv
    # direnv

    # assorted dependencies
    gnat14

    # godot_4

    tio # screen/minicom alternative
    # lazygit

    # unityhub

    # fpga stuff
    # iverilog
    # gtkwave
    # apio
    # inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-ide # IDE
    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli # CLI
  ];

  # services.udev.packages = with pkgs; [ apio-udev-rules ]; # for FPGA work  (ftdi)

  home-manager.users."${settings.userDetails.username}" = {
    imports = [
      ./git.nix
      ./vscode.nix
    ];

    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
    };

    home.packages = with pkgs; [
      # ocamlPackages.ocp-indent # for vscode indenting
      # ocamlPackages.ocaml-lsp # for ocaml lsp
      # ocamlPackages.ocamlformat-rpc-lib # i dont even know anymore

      # cmucl_binary # LSIP
      # dotnet-sdk_9
      csharp-ls # c# lsp
      icu

      alejandra
    ];

    home.sessionVariables = {
      # DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    };

    programs.gh = {
      enable = true;
      extensions = [ pkgs.gh-notify ];
      package = pkgs.gh;
    };

  };
}
