{pkgs, ...}: {
  home.packages = [
    pkgs.audacity
    pkgs.gimp
    pkgs.loupe
    pkgs.obs-studio
    pkgs.pavucontrol
    pkgs.vlc
    # pkgs.kdePackages.kdenlive
    pkgs.spotify
    pkgs.scrcpy
    pkgs.zoom
  ];
}
