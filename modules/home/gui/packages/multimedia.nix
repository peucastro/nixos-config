{pkgs, ...}: {
  home.packages = [
    pkgs.audacity
    pkgs.gimp
    pkgs.loupe
    pkgs.obs-studio
    pkgs.pavucontrol
    pkgs.vlc
    pkgs.jellyfin-desktop
    pkgs.supersonic
    pkgs.spotify
    pkgs.scrcpy
  ];
}
