{
  programs.nvf = {
    enable = true;
    settings.vim = {
      withNodeJs = true;
      withPython3 = true;
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
