{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.soulseek;
in {
  options.homeserver.services.soulseek = {
    enable = lib.mkEnableOption "Soulseek music sharing";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5030;
      description = "The TCP port on which slskd web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "soulseek.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access slskd.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Soulseek";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Peer-to-peer music sharing";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "soulseek.png";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Downloads";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.slskd = {
      enable = true;
      openFirewall = true;
      domain = null;
      environmentFile = config.age.secrets.soulseek-env.path;
      group = "media";

      settings = {
        web.port = cfg.port;
        flags = {
          noShareScan = true;
          noConfigWatch = true;
          noSqlitePooling = true;
        };
        shares = {
          directories = [];
          cache = {
            storageMode = "disk";
            retention = "1440";
            workers = 1;
          };
        };
        global.upload.slots = 1;
        groups.default.upload.slots = 1;
        soulseek.distributed_network.enabled = false;
        directories = {
          downloads = "/data/downloads/soulseek";
          incomplete = "/data/downloads/soulseek/incomplete";
        };
      };
    };

    systemd.tmpfiles.settings = {
      "20-media" = {
        "/data/downloads/soulseek".d = {
          user = "slskd";
          group = "media";
          mode = "0775";
        };
        "/data/downloads/soulseek/incomplete".d = {
          user = "slskd";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver.services.backups.paths = ["/var/lib/slskd"];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
