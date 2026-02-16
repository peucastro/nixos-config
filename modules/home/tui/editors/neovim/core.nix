{
  programs.nvf = {
    enable = true;
    settings.vim = {
      enableLuaLoader = true;
      searchCase = "smart";
      options = {
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };
    };
  };
}
