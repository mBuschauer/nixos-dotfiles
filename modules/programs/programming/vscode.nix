# home-manager import
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  overleaf-theme = pkgs.vscode-utils.buildVscodeExtension {
    pname = "overleaf-theme";
    version = "0.0.6";
    src = inputs.overleaf-theme;
    sourceRoot = "source";
    vscodeExtPublisher = "marco";
    vscodeExtName = "overleaf-theme";
    vscodeExtUniqueId = "marco.overleaf-theme";
  };
  latex-workshop = pkgs.vscode-extensions.james-yu.latex-workshop.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.jq ];
    # this patch adds auto closing
    postPatch = (old.postPatch or "") + ''
      f=syntax/latex-language-configuration.json

      jq '
        .autoClosingPairs |= (
          map(
            if   . == ["\\[", ""] then ["\\[", "\\]"]
            elif . == ["\\(", ""] then ["\\(", "\\)"]
            else . end
          ) + [["$", "$"]]
        )
      ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"

      # Fail the build if upstream changes the file and the patch stops applying
      jq -e '.autoClosingPairs | any(. == ["\\[", "\\]"])' "$f" > /dev/null
    '';
  });
in
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

            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
          ];
          userSettings = {
            "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
            "[nix]"."editor.formatOnSave" = false;

            "window.openFoldersInNewWindow" = lib.mkDefault "on";

            "claudeCode.preferredLocation" = "panel";
            "workbench.browser.openLocalhostLinks" = false;

            "workbench.iconTheme" = lib.mkDefault "vscode-icons";
            "vsicons.dontShowNewVersionMessage" = true;

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
        extensions = with pkgs.vscode-extensions; [
          latex-workshop
          valentjn.vscode-ltex
          overleaf-theme
        ];
        userSettings = {
          "workbench.experimental.modernUI" = false;
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
          "latex-workshop.view.pdf.color.light.backgroundColor" = "#495365";
          "latex-workshop.formatting.latex" = "tex-fmt";

          "workbench.colorTheme" = "mbuschauer.overleaf";
          "workbench.preferredLightColorTheme" = "mbuschauer.overleaf";
          "workbench.preferredDarkColorTheme" = "mbuschauer.overleaf";

          "editor.fontFamily" = "'DejaVu Sans Mono', monospace";
          "editor.fontSize" = 13;
          "editor.lineHeight" = 19;
          "editor.minimap.enabled" = false;
          "editor.showFoldingControls" = "always";

          # Terminal cursor
          "terminal.integrated.cursorStyle" = "block";
          "terminal.integrated.cursorBlinking" = true;
        };
        keybindings = [
          {
            key = "ctrl+b";
            command = "editor.action.insertSnippet";
            args = {
              snippet = "\\\\textbf{\${TM_SELECTED_TEXT:$0}}";
            };
            when = "editorTextFocus && !editorReadonly && editorLangId == 'latex'";
          }
          {
            key = "ctrl+i";
            command = "editor.action.insertSnippet";
            args = {
              snippet = "\\\\textit{\${TM_SELECTED_TEXT:$0}}";
            };
            when = "editorTextFocus && !editorReadonly && editorLangId == 'latex'";
          }
          {
            key = "ctrl+u";
            command = "editor.action.insertSnippet";
            args = {
              snippet = "\\\\underline{\${TM_SELECTED_TEXT:$0}}";
            };
            when = "editorTextFocus && !editorReadonly && editorLangId == 'latex'";
          }
        ];

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
