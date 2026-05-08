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
    models = "${config.services.ollama.home}/models"; # references home (/mnt/sda1/ollama/models)
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

  environment.systemPackages =
    with pkgs;
    [
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

      docker-compose

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
    ]
    ++ [
      # inputs.tsui.packages."x86_64-linux".tsui # currently broken, not going to fix now.
    ];
  # services.udev.packages = with pkgs; [ apio-udev-rules ]; # for FPGA work  (ftdi)

  home-manager.users."${settings.userDetails.username}" = {
    programs.vscode = {
      enable = true;
      # package = pkgs.vscodium; # doensn't support microsoft extensions
      package = pkgs.stable.vscode;
      profiles.default = {
        extensions =
          with pkgs.vscode-extensions;
          [
            ms-python.debugpy # Python Debugger
            ms-vscode-remote.remote-containers # Dev Containers
            ms-azuretools.vscode-docker # docker
            yzhang.markdown-all-in-one # markdown-all-in-one
            bbenoist.nix # nix
            jnoortheen.nix-ide # nix IDE
            brettm12345.nixfmt-vscode # nixfmt

            ms-python.python # Python
            ms-python.vscode-pylance # vscode-pylance
            pkgs.stable.vscode-extensions.rust-lang.rust-analyzer # rust-analyzer
            vscode-icons-team.vscode-icons # vscode-icons
            dotjoshjohnson.xml # xml tools
            mhutchie.git-graph # git graph
            ms-vscode.cmake-tools # cmake tools
            ms-vscode.live-server # live preview
            ms-vscode.makefile-tools # makefile tools

            tamasfe.even-better-toml # toml markup
            # ocamllabs.ocaml-platform # ocaml support
            mattn.lisp # LISP Support

            tomoki1207.pdf # vscode-pdf

            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-dotnettools.csharp

          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              # good formatter for python
              name = "autopep8";
              publisher = "ms-python";
              version = "2024.0.0";
              sha256 = "37d6d46763ada1846d2c468a47274510f392f28922d44e339ab8f5baf6aa0703";
            }
            # {
            #   # bend language support
            #   name = "Bend";
            #   publisher = "rohanvashisht";
            #   version = "0.2.14";
            #   sha256 = "63c73c0791f33082fbfc81c54dc8b2ac08a5a482226c1598b2c25e3b37f8252a";
            # }
            # {
            #   # sftp support
            #   name = "SFTP";
            #   publisher = "Natizyskunk";
            #   version = "1.16.3";
            #   sha256 = "sha256-HifPiHIbgsfTldIeN9HaVKGk/ujaZbjHMiLAza/o6J4";
            # }
            # {
            #   # for assembly support
            #   name = "asm-code-lens";
            #   publisher = "maziac";
            #   version = "2.6.1";
            #   sha256 = "sha256-XMBBavtkS2b1OkXRD66ZsFzO5LkSTvazLVyEKlzYyG8=";
            # }
          ];
        userSettings = {
          "window.openFoldersInNewWindow" = "on";
          "workbench.iconTheme" = "vscode-icons";
          "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
          "[nix]"."editor"."defaultFormatter" = "brettm12345.nixfmt-vscode";
          "[nix]"."editor"."formatOnSave" = false;
          "[ javascript ]"."editor"."defaultFormatter" = "esbenp.prettier-vscode";
          "[javascriptreact]"."editor"."defaultFormatter" = "esbenp.prettier-vscode";
          "[markdown]"."editor"."defaultFormatter" = "yzhang.markdown-all-in-one";
          "[css]"."editor"."defaultFormatter" = "vscode.css-language-features";
          "[latex]"."editor"."wordWrap" = "on";
          "nixEnvSelector"."useFlakes" =  true;
          "[json]"."editor"."defaultFormatter" = "vscode.json-language-features";
        };
      };
    };

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

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "${secrets.gitUser}";
          email = "${secrets.gitEmail}";
        };
        merge = {
          "ours" = {
            driver = true;
          };
        };
        submodule = {
          recurse = true;
        };
      };
      signing = {
        format = "openpgp";
        signer = "${pkgs.gnupg}/bin/gpg";
        key = "${secrets.gpgFingerprint}"; # gpg --list-keys --fingerprint
        signByDefault = true;
      };
    };
  };
}
