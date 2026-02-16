{
  programs.nvf.settings.vim.filetree.nvimTree = {
    enable = true;
    openOnSetup = false;

    setupOpts = {
      git.enable = true;
      view.side = "right";

      actions.open_file.quit_on_open = true;
      update_focused_file = {
        enable = true;
        update_root = true;
      };

      renderer = {
        group_empty = true;
        icons.show.git = true;
        indent_markers.enable = true;
      };
    };
  };
}
