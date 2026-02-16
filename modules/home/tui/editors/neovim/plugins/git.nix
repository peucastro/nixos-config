{
  programs.nvf.settings.vim.git = {
    enable = true;
    neogit.enable = true;

    gitsigns = {
      enable = true;
      setupOpts = {
        numhl = true;
        current_line_blame = true;
      };
      mappings = {
        blameLine = "<leader>ghb";
        diffProject = "<leader>ghD";
        diffThis = "<leader>ghd";
        nextHunk = "<leader>gh[c";
        previousHunk = "<leader>gh]c";
        previewHunk = "<leader>ghP";
        resetBuffer = "<leader>ghR";
        resetHunk = "<leader>ghr";
        stageBuffer = "<leader>ghS";
        stageHunk = "<leader>ghs";
        undoStageHunk = "<leader>ghu";
        toggleBlame = "<leader>ghtb";
        toggleDeleted = "<leader>ghtd";
      };
    };

    git-conflict = {
      enable = true;
      mappings = {
        both = "<leader>gxb";
        none = "<leader>gx0";
        ours = "<leader>gxo";
        theirs = "<leader>gxt";
        nextConflict = "<leader>gx[x";
        prevConflict = "<leader>gx]x";
      };
    };
  };
}
