{
  lib,
  pkgs,
  ...
}: let
  defaultExtensions = [
    pkgs.vscode-extensions.adpyke.codesnap
    pkgs.vscode-extensions.usernamehw.errorlens
    pkgs.vscode-extensions.github.copilot
    pkgs.vscode-extensions.github.copilot-chat
    pkgs.vscode-extensions.jdinhlife.gruvbox
    pkgs.vscode-extensions.davidanson.vscode-markdownlint
    pkgs.vscode-extensions.pkief.material-icon-theme
    pkgs.vscode-extensions.pkief.material-product-icons
    pkgs.vscode-extensions.jnoortheen.nix-ide
    pkgs.vscode-extensions.ms-vsliveshare.vsliveshare
    pkgs.vscode-extensions.mkhl.direnv
  ];

  defaultUserSettings = {
    "editor.fontFamily" = "'JetBrains Mono'";
    "editor.fontSize" = 18;
    "editor.lineHeight" = 1.5;
    "diffEditor.ignoreTrimWhitespace" = false;
    "editor.accessibilitySupport" = "off";
    "editor.folding" = false;
    "editor.formatOnPaste" = true;
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.guides.bracketPairs" = true;
    "editor.linkedEditing" = true;
    "editor.minimap.enabled" = false;
    "editor.renderLineHighlight" = "gutter";
    "editor.renderWhitespace" = "boundary";
    "editor.wordWrap" = "on";
    "explorer.compactFolders" = false;
    "explorer.sortOrderLexicographicOptions" = "unicode";
    "files.autoSave" = "afterDelay";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.trimTrailingWhitespace" = true;
    "workbench.colorTheme" = "Gruvbox Dark Hard";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.productIconTheme" = "material-product-icons";
    "workbench.sideBar.location" = "right";
    "debug.console.closeOnEnd" = true;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.fontFamily" = "'FiraCode Nerd Font Mono'";
    "terminal.integrated.fontSize" = 15;
    "extensions.autoUpdate" = false;
    "extensions.ignoreRecommendations" = true;
    "github.copilot.enable" = {"*" = false;};
    "git.autofetch" = true;
    "git.blame.statusBarItem.enabled" = false;
    "git.openRepositoryInParentFolders" = "always";
    "telemetry.feedback.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "manual";
    "window.zoomLevel" = 0.25;
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings" = {
      "nixd" = {
        "formatting" = {
          "command" = ["alejandra"];
        };
      };
    };
    "nix.formatterPath" = "alejandra";
  };

  mkProfile = extra: {
    extensions = defaultExtensions ++ (extra.extensions or []);
    userSettings = lib.recursiveUpdate defaultUserSettings (extra.userSettings or {});
  };
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;

    profiles = {
      default = mkProfile {};

      python = mkProfile {
        extensions = [
          pkgs.vscode-extensions.charliermarsh.ruff
          pkgs.vscode-extensions.formulahendry.code-runner
          pkgs.vscode-extensions.mechatroner.rainbow-csv
          pkgs.vscode-extensions.ms-python.debugpy
          pkgs.vscode-extensions.ms-python.isort
          pkgs.vscode-extensions.ms-python.python
          pkgs.vscode-extensions.ms-python.vscode-pylance
          pkgs.vscode-extensions.ms-toolsai.jupyter
          pkgs.vscode-extensions.ms-toolsai.jupyter-keymap
          pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
          pkgs.vscode-extensions.ms-toolsai.vscode-jupyter-cell-tags
          pkgs.vscode-extensions.ms-toolsai.vscode-jupyter-slideshow
        ];
        userSettings = {
          "[python]" = {"editor.defaultFormatter" = "charliermarsh.ruff";};
        };
      };

      latex = mkProfile {
        extensions = [
          pkgs.vscode-extensions.james-yu.latex-workshop
          pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
          pkgs.vscode-extensions.myriad-dreamin.tinymist
        ];
        userSettings = {
          "latex-workshop.formatting.latex" = "tex-fmt";
          "latex-workshop.latex.autoClean.run" = "onBuilt";
          "latex-workshop.latex.build.rootfileInStatus" = true;
          "latex-workshop.latex.build.forceRecipeUsage" = false;
          "[latex]" = {"editor.defaultFormatter" = "James-Yu.latex-workshop";};
        };
      };

      webdev = mkProfile {
        extensions = [
          pkgs.vscode-extensions.astro-build.astro-vscode
          pkgs.vscode-extensions.bmewburn.vscode-intelephense-client
          pkgs.vscode-extensions.bradlc.vscode-tailwindcss
          pkgs.vscode-extensions.esbenp.prettier-vscode
          pkgs.vscode-extensions.biomejs.biome
          pkgs.vscode-extensions.christian-kohler.path-intellisense
          pkgs.vscode-extensions.ritwickdey.liveserver
          pkgs.vscode-extensions.ms-vscode.live-server
          pkgs.vscode-extensions.svelte.svelte-vscode
          pkgs.vscode-marketplace.laravel.vscode-laravel
        ];
        userSettings = {
          "svelte.enable-ts-plugin" = true;
          "[astro]" = {"editor.defaultFormatter" = "biomejs.biome";};
          "[php]" = {"editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";};
        };
      };

      c-cpp = mkProfile {
        extensions = [
          pkgs.vscode-extensions.ms-vscode.cpptools
          pkgs.vscode-extensions.ms-vscode.makefile-tools
          pkgs.vscode-extensions.ms-vscode.cmake-tools
        ];
        userSettings = {
          "[c]" = {"editor.defaultFormatter" = "ms-vscode.cpptools";};
          "[cpp]" = {"editor.defaultFormatter" = "ms-vscode.cpptools";};
          "makefile.configureOnOpen" = false;
          "editor.largeFileOptimizations" = false;
        };
      };

      flutter = mkProfile {
        extensions = [
          pkgs.vscode-extensions.dart-code.flutter
          pkgs.vscode-extensions.dart-code.dart-code
          pkgs.vscode-extensions.jebbs.plantuml
        ];
        userSettings = {
          "dart.flutterCustomEmulators" = [
            {
              id = "pixel9";
              name = "Pixel 9";
              executable = "flutter";
              args = ["emulator" "--launch" "Pixel_9"];
            }
          ];
        };
      };
    };
  };
}
