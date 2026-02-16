{
  programs.nvf.settings.vim = {
    binds = {
      whichKey = {
        enable = true;
        register = {
          "<leader>f" = "Telescope";
          "<leader>g" = "Git";
          "<leader>gh" = "Hunk Actions";
          "<leader>h" = null;
          "<leader>gx" = "Conflicts";
          "<leader>l" = "LSP";
          "<leader>q" = "Quit/Session";
          "<leader>t" = "NvimTree";
          "<leader>w" = "Windows";
          "<leader>x" = "Trouble";
        };
      };
      cheatsheet.enable = true;
    };

    keymaps = [
      # Window Management
      {
        key = "<leader>wv";
        mode = "n";
        action = ":vsplit<CR>";
        silent = true;
        desc = "Split Vertical";
      }
      {
        key = "<leader>ws";
        mode = "n";
        action = ":split<CR>";
        silent = true;
        desc = "Split Horizontal";
      }
      {
        key = "<leader>wd";
        mode = "n";
        action = "<C-w>q";
        silent = true;
        desc = "Close Window";
      }
      {
        key = "<leader>ww";
        mode = "n";
        action = "<C-w>w";
        silent = true;
        desc = "Switch Window";
      }

      # Quit/Session Management
      {
        key = "<leader>qq";
        mode = "n";
        action = ":qa<CR>";
        silent = true;
        desc = "Quit All";
      }
      {
        key = "<leader>qw";
        mode = "n";
        action = ":wa<CR>";
        silent = true;
        desc = "Save All Files";
      }
      {
        key = "<leader>qs";
        mode = "n";
        action = ":mksession!<CR>";
        silent = true;
        desc = "Save Session";
      }
    ];
  };
}
