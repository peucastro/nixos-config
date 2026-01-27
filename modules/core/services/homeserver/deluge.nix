{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.deluge;
in {
  options.homeserver.services.deluge = {
    enable = lib.mkEnableOption "Deluge BitTorrent client";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8112;
      description = "The TCP port on which the Deluge Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "torrent.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Deluge.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Deluge";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "BitTorrent client with web UI";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "deluge.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Downloads";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      declarative = true;
      group = "media";
      web = {
        enable = true;
        inherit (cfg) port;
      };
      config = {
        download_location = "/data/downloads/incomplete";
        move_completed = true;
        move_completed_path = "/data/downloads";
        upnp = false;
        natpmp = false;
      };
      authFile = config.age.secrets.deluge-auth.path;
    };

    systemd.tmpfiles.settings = {
      "10-media" = {
        "/data/downloads".d = {
          user = "media";
          group = "media";
          mode = "0775";
        };
        "/data/downloads/incomplete".d = {
          user = "media";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver.services.backups.paths = [config.services.deluge.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
