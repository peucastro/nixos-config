{inputs, ...}: {
  imports = [
    inputs.nvf.homeModules.default

    ./plugins
    ./binds.nix
    ./core.nix
    ./languages.nix
    ./lsp.nix
    ./theme.nix
    ./visuals.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
