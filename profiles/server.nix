{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../secrets/default.nix
    ../secrets/server.nix
    ../modules/core/base
    ../modules/core/hardware
    ../modules/core/server
  ];

  boot.loader = {
    systemd-boot.enable = true;
    grub.enable = false;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = config.homeserver.timeZone;
  custom.locale = "en_US";

  networking = {
    useDHCP = false;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    firewall = {
      enable = true;
      rejectPackets = true;
      allowedTCPPorts = [22];
      checkReversePath = "loose";
    };
  };

  services.xserver.enable = false;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  environment.systemPackages = [
    # Networking tools
    pkgs.curl
    pkgs.dig
    pkgs.socat

    # System monitoring
    pkgs.btop
    pkgs.fastfetch
    pkgs.ncdu
    pkgs.powertop

    # Search and navigation
    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
    pkgs.tree
    pkgs.tmux
  ];
}
