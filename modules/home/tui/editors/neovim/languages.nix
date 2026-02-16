{
  programs.nvf.settings.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    astro.enable = true;
    bash.enable = true;
    clang.enable = true;
    css.enable = true;
    dart.enable = true;
    go.enable = true;
    haskell.enable = true;
    html.enable = true;
    java.enable = true;
    json.enable = true;
    kotlin.enable = true;
    lua.enable = true;
    markdown.enable = true;
    nix = {
      enable = true;
      lsp.servers = ["nixd"];
    };
    python.enable = true;
    rust.enable = true;
    scala.enable = true;
    sql.enable = true;
    svelte.enable = true;
    tailwind.enable = true;
    ts = {
      enable = true;
      extensions.ts-error-translator.enable = true;
    };
    yaml.enable = true;
  };
}
