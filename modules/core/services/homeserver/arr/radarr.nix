{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.radarr;
in {
  options.homeserver.services.radarr = {
    enable = lib.mkEnableOption "Radarr movie manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 7878;
      description = "The TCP port on which the Radarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "movies.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Radarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Radarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Movie collection manager for Usenet and BitTorrent";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "radarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      settings.server = {
        inherit (cfg) port;
        bindAddress = "127.0.0.1";
      };
      group = "media";
      environmentFiles = [config.age.secrets.radarr-api-key.path];
    };

    systemd.tmpfiles.settings = {
      "20-media" = {
        "/data/media/movies".d = {
          user = "radarr";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver.services.backups.paths = [config.services.razarr.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
