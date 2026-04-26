{pkgs, ...}: {
  home.packages = [
    pkgs.gemini-cli
    pkgs.opencode
    pkgs.pi-coding-agent
    pkgs.lazydocker
  ];
}
