let
  inherit (import ./colors.nix) colors;
in
  {
    pkgs,
    config,
    ...
  }: let
    inherit (config.lib.formats.rasi) mkLiteral;
  in {
    programs.rofi = {
      enable = true;
      plugins = [pkgs.rofi-emoji];

      settings = {
        cycle = true;
        modes = ["drun" "emoji"];
        terminal = "${pkgs.alacritty}/bin/alacritty";
        font = "Inter 12";
        show-icons = true;
        icon-theme = "Adwaita";
      };

      theme = {
        "*" = {
          bg0 = mkLiteral "#${colors.background-dim}";
          bg1 = mkLiteral "#${colors.background-alt}";
          fg0 = mkLiteral "#${colors.foreground}";
          grey0 = mkLiteral "#${colors.gray}";
          border-color = mkLiteral "#${colors.border}";
          selected-bg = mkLiteral "#${colors.selection}";
          urgent-bg = mkLiteral "#${colors.urgent}";

          background-color = mkLiteral "@bg0";
        };

        "window" = {
          width = 800;
          height = 500;
          border = 2;
          border-radius = 5;
          border-color = mkLiteral "@border-color";
        };

        "mainbox" = {
          spacing = 0;
          children = map mkLiteral ["inputbar" "message" "listview"];
        };

        "inputbar" = {
          color = mkLiteral "@fg0";
          padding = 14;
          background-color = mkLiteral "@bg0";
        };

        "message" = {
          padding = 10;
          background-color = mkLiteral "@grey0";
        };

        "listview" = {
          padding = 8;
          border-radius = mkLiteral "0 0 5 5";
          border = mkLiteral "2 2 2 2";
          border-color = mkLiteral "@bg0";
          background-color = mkLiteral "@bg0";
          dynamic = false;
        };

        "textbox" = {
          text-color = mkLiteral "@fg0";
          background-color = mkLiteral "inherit";
        };

        "error-message" = {
          border = mkLiteral "20 20 20 20";
        };

        "entry, prompt, case-indicator" = {
          text-color = mkLiteral "inherit";
        };

        "prompt" = {
          margin = mkLiteral "0 10 0 0";
        };

        "element" = {
          padding = 5;
          vertical-align = mkLiteral "0.5";
          border-radius = 5;
          background-color = mkLiteral "@bg1";
        };

        "element.selected.normal" = {
          background-color = mkLiteral "@grey0";
        };

        "element.alternate.normal" = {
          background-color = mkLiteral "inherit";
        };

        "element.normal.active, element.alternate.active" = {
          background-color = mkLiteral "@selected-bg";
        };

        "element.selected.active" = {
          background-color = mkLiteral "@selected-bg";
        };

        "element.normal.urgent, element.alternate.urgent" = {
          background-color = mkLiteral "@urgent-bg";
        };

        "element.selected.urgent" = {
          background-color = mkLiteral "@urgent-bg";
        };

        "element-text, element-icon" = {
          size = 30;
          margin = mkLiteral "0 10 0 0";
          vertical-align = mkLiteral "0.5";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "@fg0";
        };

        "element-text.active, element-text.urgent" = {
          text-color = mkLiteral "@bg0";
        };
      };
    };
  }
