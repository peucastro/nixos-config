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
        flags.noConfigWatch = true;
        shares = {
          directories = ["/var/lib/slskd/shared"];
          cache = {
            enabled = true;
            storageMode = "disk";
          };
        };
        global.upload.slots = 1;
        groups.default.upload.slots = 1;
        soulseek.distributed_network.enabled = true;
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
        "/var/lib/slskd/shared".d = {
          user = "slskd";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver = {
      services.backups.restic.paths = ["/var/lib/slskd"];
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
