{
  imports = [
    ./hardware-configuration.nix
    ./state-configuration.nix
    ../../secrets
    ../../profiles/server.nix
    ../../modules/core/services/homeserver
  ];

  networking = {
    hostName = "kim";
    # FIXME
    interfaces.___.ipv4.addresses = [
      {
        address = "192.168.1.100";
        prefixLength = 24;
      }
    ];
  };

  homeserver = {
    timeZone = "Europe/Lisbon";
    lanIp = "10.0.0.0"; # FIXME
    services = {
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
      deluge.enable = true;
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
