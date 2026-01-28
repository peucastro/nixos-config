{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./state-configuration.nix
    ../../secrets
    ../../profiles/server.nix
    ../../modules/core/services/homeserver
  ];

  networking = {
    hostName = "kim";
    defaultGateway = "192.168.1.1";
    interfaces.enp2s0.ipv4.addresses = [
      {
        address = "192.168.1.100";
        prefixLength = 24;
      }
    ];
  };

  homeserver = {
    timeZone = "Europe/Lisbon";
    lanIp = "192.168.1.100";
    services = {
      caddy.enable = true;
      tailscale.enable = true;
      adguardhome.enable = true;
      homepage.enable = true;
      filebrowser.enable = true;
      immich.enable = true;
      jellyfin.enable = true;
      bazarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      prowlarr.enable = true;
      qbittorrent.enable = true;
      jellyseerr.enable = true;
      glances.enable = true;
      uptime-kuma.enable = true;
      backups = {
        enable = true;
        repository = "/mnt/backups";
        passwordFile = "/mnt/backups/restic-password";
      };
    };
  };
}
