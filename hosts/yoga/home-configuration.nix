{user, ...}: let
  username = user.login;
in {
  home-manager.users."${username}".imports = [
    ../../modules/home
  ];

  programs.hyprland.enable = true;
}
