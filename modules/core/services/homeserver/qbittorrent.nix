{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.qbittorrent;
in {
  options.homeserver.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent client";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The TCP port on which the qBittorrent Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "torrent.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access qBittorrent.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "qBittorrent";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Bittorrent client with web UI";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "qbittorrent.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Downloads";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for qBittorrent";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      webuiPort = cfg.port;
      group = "media";
      serverConfig = {
        Preferences.WebUI.Address = "127.0.0.1";
      };
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

    homeserver = {
      services = {
        qbittorrent.homepage.widget = {
          type = "qbittorrent";
          url = "http://127.0.0.1:${toString cfg.port}";
          username = "{{HOMEPAGE_VAR_USERNAME}}";
          password = "{{HOMEPAGE_VAR_PASSWORD}}";
          enableLeechProgress = true;
          enableLeechSize = true;
        };
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
