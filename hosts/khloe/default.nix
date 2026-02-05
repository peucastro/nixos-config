{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../secrets
    ../../profiles/server.nix
    ../../modules/core/services/homeserver
  ];

  virtualisation.virtualbox.guest.enable = true;
  users.users.homeserver.extraGroups = ["vboxsf"];

  networking = {
    hostName = "khloe";
    interfaces.enp0s3.ipv4.addresses = [
      {
        address = "192.168.1.100";
        prefixLength = 24;
      }
    ];
  };
  system.stateVersion = "25.11";

  homeserver = {
    timeZone = "Europe/Lisbon";
    lanIp = "10.0.2.15";
    services = {
      # Monitoring
      glances.enable = true;
      monitoring.enable = true;
      uptime-kuma.enable = true;

      # Networking
      adguardhome.enable = true;
      caddy.enable = true;
      tailscale.enable = true;

      # Utilities
      filebrowser.enable = true;
      homepage.enable = true;
      miniflux.enable = true;
      stirling-pdf.enable = true;

      # Media
      calibre-web.enable = true;
      immich.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      navidrome.enable = true;

      # Servarr
      bazarr.enable = true;
      lidarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sonarr.enable = true;

      # Downloads
      deluge.enable = true;
      qbittorrent = {
        enable = true;
        hostname = "qbittorrent.${config.homeserver.baseDomain}";
      };
      soulseek.enable = true;
      transmission = {
        enable = true;
        hostname = "transmission.${config.homeserver.baseDomain}";
      };

      # Backups
      backups = {
        enable = true;
        restic = {
          passwordFile = "/home/homeserver/backups/restic-password";

          targets.local = {
            repository = "/home/homeserver/backups";
            timer = "daily";
          };
        };
      };
    };
  };
}
