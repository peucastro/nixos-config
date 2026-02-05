{config, ...}: {
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

  custom.gpuChoice = "intel";

  homeserver = {
    timeZone = "Europe/Lisbon";
    lanIp = "192.168.1.100";
    motd.enable = true;
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
      sonarr.enable = true;

      # Downloads
      soulseek.enable = true;
      transmission.enable = true;

      # Backups
      backups = {
        enable = true;
        restic = {
          passwordFile = "/mnt/backups/restic-password";
          targets = {
            local = {
              repository = "/mnt/backups/restic";
              timer = "daily";
              healthchecksId = "6778ad5a-fced-4e9e-9248-583601971159";
            };
            remote = {
              repository = "s3:https://s3.eu-central-003.backblazeb2.com/kim-backups";
              environmentFile = config.age.secrets.backblaze-api-key.path;
              timer = "weekly";
              healthchecksId = "19657ed7-1126-4ee7-bd3a-dea6bb082581";
            };
          };
        };
        postgresql.location = "/mnt/backups/postgres";
      };
    };
  };
}
