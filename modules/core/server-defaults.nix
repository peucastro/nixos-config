{
  environment.variables = {
    BROWSER = "echo";
  };

  fonts.fontconfig.enable = false;

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  documentation = {
    enable = false;
    nixos.enable = false;
    info.enable = false;
    man.enable = false;
    doc.enable = false;
  };
}
