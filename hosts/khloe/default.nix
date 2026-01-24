{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../secrets
    ../../profiles/server.nix
    ../../modules/core/services/homeserver
  ];

  virtualisation.virtualbox.guest.enable = true;
  users.users.homeserver.extraGroups = ["vboxsf"];

  networking.hostName = "khloe";
  system.stateVersion = "25.11";

  homeserver = {
    timeZone = "Europe/Lisbon";
    lanIp = "10.0.2.15";
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
      qbittorrent = {
        enable = true;
        hostname = "qbittorrent.${config.homeserver.baseDomain}";
      };
      deluge.enable = true;
      jellyseerr.enable = true;
      glances.enable = true;
      uptime-kuma.enable = true;
      backups = {
        enable = true;
        repository = "/home/homeserver/backups";
        passwordFile = "/home/homeserver/restic-password";
      };
    };
  };
}
