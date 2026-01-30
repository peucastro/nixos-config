{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.jellyfin;
in {
  options.homeserver.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "watch.${config.homeserver.baseDomain}";
      description = "Public hostname for Jellyfin";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Jellyfin";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Media streaming server";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      group = "media";
    };

    users = {
      users.media = {
        isSystemUser = true;
        group = "media";
      };
      groups.media = {};
    };

    systemd = {
      services.jellyfin.environment.MALLOC_TRIM_THRESHOLD_ = "100000";

      tmpfiles.settings = {
        "10-media" = {
          "/data/media".d = {
            user = "media";
            group = "media";
            mode = "0775";
          };
        };
      };
    };

    homeserver.services.backups.paths = [config.services.jellyfin.dataDir];

    homeserver.caddy.vhosts = [
      {
        inherit (cfg) hostname;
        port = 8096;
      }
    ];
  };
}
