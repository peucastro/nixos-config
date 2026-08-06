{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = 24;
  };

  home.packages = [
    pkgs.libsForQt5.qt5ct
    pkgs.kdePackages.qt6ct
  ];
}
