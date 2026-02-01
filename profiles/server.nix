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
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  services = {
    xserver.enable = false;

    postgresql = {
      enable = true;
      settings = {
        max_connections = 300;
        shared_buffers = "1024MB";
      };
    };
  };

  powerManagement.powertop.enable = true;

  environment.systemPackages = [
    # Networking tools
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
