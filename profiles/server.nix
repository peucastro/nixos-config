{
  pkgs,
  config,
  secrets,
  ...
}: {
  imports = [
    ../modules/core/base
    ../modules/core/server
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  time.timeZone = config.homeserver.timeZone;

  i18n.defaultLocale = "en_US.UTF-8";
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
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    firewall = {
      enable = true;
      rejectPackets = true;
      allowedTCPPorts = [22];
    };
  };

  services.xserver.enable = false;

  age.secrets = {
    homeserver = {
      file = "${secrets}/homeserver.age";
      path = "/home/homeserver/.ssh/homeserver";
      symlink = true;
      mode = "0400";
      owner = "homeserver";
      group = "users";
    };
    caddy-env = {
      file = "${secrets}/caddy_env.age";
      mode = "0400";
      owner = "caddy";
      group = "caddy";
    };
    deluge-auth = {
      file = "${secrets}/deluge-auth.age";
      mode = "0400";
      owner = config.services.deluge.user;
      group = config.services.deluge.group;
    };
    radarr-api-key = {
      file = "${secrets}/radarr-api-key.age";
      mode = "0400";
      owner = config.services.radarr.user;
      group = config.services.radarr.group;
    };
    sonarr-api-key = {
      file = "${secrets}/sonarr-api-key.age";
      mode = "0400";
      owner = config.services.sonarr.user;
      group = config.services.sonarr.group;
    };
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

    # Search and navigation
    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
    pkgs.tree
    pkgs.tmux
  ];
}
