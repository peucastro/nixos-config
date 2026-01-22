{pkgs, ...}: {
  environment.systemPackages = [
    # Editors
    pkgs.vim

    # Utilities
    pkgs.git

    # Networking tools
    pkgs.wget
    pkgs.curl
    pkgs.dig
    pkgs.socat

    # System monitoring
    pkgs.btop
    pkgs.fastfetch
    pkgs.ncdu

    # Search and navigation
    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
    pkgs.tree
    pkgs.tmux
  ];
}
