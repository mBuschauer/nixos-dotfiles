# home-manager import
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.vscode.profiles = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            arrterian.nix-env-selector

            vscode-icons-team.vscode-icons

            yzhang.markdown-all-in-one # markdown-all-in-one
            github.vscode-github-actions

            anthropic.claude-code

            tamasfe.even-better-toml
            redhat.vscode-yaml
            esbenp.prettier-vscode

            ms-azuretools.vscode-docker
          ];
          userSettings = {
            "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
            "[nix]"."editor.formatOnSave" = false;
            "nixEnvSelector.useFlakes" = true;

            "window.openFoldersInNewWindow" = lib.mkDefault "on";

            "claudeCode.preferredLocation" = "panel";
            "workbench.browser.openLocalhostLinks" = false;
            "workbench.iconTheme" = lib.mkDefault "vscode-icons";

            "chat.disableAIFeatures" = true;

            "[markdown]"."editor.defaultFormatter" = "yzhang.markdown-all-in-one";
            "[json]"."editor.defaultFormatter" = "vscode.json-language-features";
            "[jsonc]"."editor.defaultFormatter" = "vscode.json-language-features";
            "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "yaml.disableSchemaDetection" = [
              "**/docker-compose.yml"
              "**/docker-compose.yaml"
              "**/docker-compose.*.yml"
              "**/docker-compose.*.yaml"
              "**/compose.yml"
              "**/compose.yaml"
              "**/compose.*.yml"
              "**/compose.*.yaml"
              "**/.github/workflows/*.yml"
              "**/.github/workflows/*.yaml"
              "**/.gitea/workflows/*.yml"
              "**/.gitea/workflows/*.yaml"
              "**/.forgejo/workflows/*.yml"
              "**/.forgejo/workflows/*.yaml"
            ];
          };
        };
      }
    );
  };

  config.programs.vscode = {
    enable = true;
    profiles = {
      default = { };
      rust = {
        extensions = with pkgs.vscode-extensions; [ rust-lang.rust-analyzer ];
        userSettings = { };
      };
      python = {
        extensions = with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.vscode-pylance # vscode-pylance
          charliermarsh.ruff # linter
          ms-toolsai.jupyter
        ];
      };
      webdev = {
        extensions = with pkgs.vscode-extensions; [
          ms-vscode.live-server # live preview
          svelte.svelte-vscode
          bradlc.vscode-tailwindcss
          dbaeumer.vscode-eslint
        ];
        userSettings = {
          "[ javascript ]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[javascriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[css]"."editor.defaultFormatter" = "vscode.css-language-features";
          "[typescriptreact]"."editor.defaultFormatter" = "vscode.typescript-language-features";
          "[typescript]"."editor.defaultFormatter" = "vscode.typescript-language-features";
        };
      };
      latex = {
        extensions =
          with pkgs.vscode-extensions;
          [
            james-yu.latex-workshop
            valentjn.vscode-ltex
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "overleaf-theme";
              publisher = "ariqahmer";
              version = "0.0.1";
              sha256 = "sha256-mwqaXkOGVUNZ5i4M0KxRIUFzNjxvQTDZWj3/7o59g/Q=";
            }
          ];
        userSettings = {
          "[latex]"."editor.wordWrap" = "on";
          "latex-workshop.latex.autoClean.run" = "onBuilt";
          "latex-workshop.latex.clean.method" = "glob";
          "latex-workshop.latex.clean.fileTypes" = [
            "*.aux"
            "*.bbl"
            "*.blg"
            "*.idx"
            "*.ind"
            "*.lof"
            "*.lot"
            "*.out"
            "*.toc"
            "*.fls"
            "*.log"
            "*.fdb_latexmk"
            "*.nav"
            "*.snm"
            "*.vrb"
            "*.synctex(busy)"
            "*.synctex.gz(busy)"
          ];
          "latex-workshop.view.pdf.viewer" = "tab";

          "workbench.colorTheme" = "Overleaf Theme";
          "workbench.preferredLightColorTheme" = "Overleaf Theme";
          "workbench.preferredDarkColorTheme" = "Overleaf Theme";

          "editor.fontFamily" = "'DejaVu Sans Mono', monospace";
          "editor.fontSize" = 13;
        };
      };
      ccpp = {
        extensions =
          with pkgs.vscode-extensions;
          [
            ms-vscode.cmake-tools # cmake tools
            llvm-vs-code-extensions.vscode-clangd
            # ms-dotnettools.csharp
            ms-vscode.cmake-tools
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # {
            #   name = "cmake-intellisence";
            #   publisher = "kylinideteam";
            #   version = "0.8.2";
            #   sha256 = pkgs.lib.fakeHash;
            # }
          ];
        userSettings = {
          "cmake.configureOnEdit" = false;
          "cmake.configureOnOpen" = false;
        };
      };
      rlang = {
        extensions = with pkgs.vscode-extensions; [
          reditorsupport.r
          reditorsupport.r-syntax
        ];
        userSettings = {

        };
      };

    };
  };
}
