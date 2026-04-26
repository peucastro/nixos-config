{
  user,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.protonup-qt
    pkgs.mangohud
    pkgs.lutris-unwrapped
    pkgs.heroic
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user.login}/.local/share/Steam/compatibilitytools.d";
  };
}
