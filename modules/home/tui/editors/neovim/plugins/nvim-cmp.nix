{
  programs.nvf.settings.vim.autocomplete.nvim-cmp = {
    enable = true;
    sources = {
      nvim_lsp = "[LSP]";
      path = "[Path]";
      buffer = "[Buffer]";
      luasnip = "[Snip]";
      nvim_lua = "[Lua]";
      cmdline = "[Cmd]";
      git = "[Git]";
    };
    mappings = {
      complete = "<C-Space>";
      next = "<C-n>";
      previous = "<C-p>";
      confirm = "<CR>";
      close = "<C-e>";
      scrollDocsUp = "<C-b>";
      scrollDocsDown = "<C-f>";
    };
  };
}
