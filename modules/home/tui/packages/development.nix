{pkgs, ...}: {
  home.packages = [
    pkgs.gemini-cli
    pkgs.opencode
    pkgs.lazydocker
  ];
}
