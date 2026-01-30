{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.lidarr;
in {
  options.homeserver.services.lidarr = {
    enable = lib.mkEnableOption "Lidarr music manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8686;
      description = "The TCP port on which the Lidarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "music.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Lidarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Lidarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Music collection manager for Usenet and BitTorrent";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "lidarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.lidarr = {
      enable = true;
      group = "media";
      settings = {
        server = {
          inherit (cfg) port;
          bindAddress = "127.0.0.1";
        };
      };
      environmentFiles = [config.age.secrets.radarr-api-key.path];
    };

    systemd.tmpfiles.settings = {
      "20-media" = {
        "/data/media/music".d = {
          user = "lidarr";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver.services.backups.paths = [config.services.lidarr.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
