{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "dart"
      "dockerfile"
      "latex"
      "make"
      "markdownlint"
      "material-icon-theme"
      "nix"
      "perplexity"
      "php"
      "sql"
      "svelte"
    ];
    userSettings = {
      theme = "Gruvbox Dark Hard";
      icon_theme = "Material Icon Theme";
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      current_line_highlight = "gutter";
      base_keymap = "VSCode";
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
      buffer_font_size = 16;
      buffer_line_height = {
        custom = 1.5;
      };
      edit_predictions_disabled_in = ["comment" "string"];
      journal = {
        hour_format = "hour24";
      };
      project_panel = {
        dock = "right";
        scrollbar = {
          show = "auto";
        };
      };
      show_completions_on_input = false;
      show_edit_predictions = false;
      tabs = {
        show_close_button = "always";
        file_icons = true;
        git_status = true;
      };
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      terminal = {
        toolbar = {
          breadcrumbs = false;
        };
        font_family = "FiraCode Nerd Font Mono";
        font_size = 15;
        line_height = "standard";
        working_directory = "first_project_directory";
      };
      ui_font_size = 16;
    };
  };
}
