{
  programs.nvf.settings.vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    mappings = {
      complete = "<C-Space>";
      next = "<C-n>";
      previous = "<C-p>";
      confirm = "<CR>";
      close = "<C-e>";
      scrollDocsUp = "<C-b>";
      scrollDocsDown = "<C-f>";
    };

    setupOpts = {
      signature.enabled = true;
      cmdline = {
        keymap.preset = "cmdline";
        sources = ["path" "cmdline"];
      };
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
        "ripgrep"
        "spell"
      ];
    };

    sourcePlugins = {
      ripgrep.enable = true;
      spell.enable = true;
    };
  };
}
