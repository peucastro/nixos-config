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
    # pkgs.kdePackages.kdenlive
    pkgs.spotify
    pkgs.scrcpy
  ];
}
