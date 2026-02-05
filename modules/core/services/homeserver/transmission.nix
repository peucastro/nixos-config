{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.transmission;
in {
  options.homeserver.services.transmission = {
    enable = lib.mkEnableOption "Transmission BitTorrent client";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9091;
      description = "The RPC port on which the Transmission will listen to.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "torrent.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Transmission.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Transmission";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Bittorrent client with web UI";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "transmission.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Downloads";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for Transmission";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.transmission = {
      enable = true;
      group = "media";
      settings = {
        rpc-port = cfg.port;
        download-dir = "/data/downloads/torrent/complete";
        incomplete-dir = "/data/downloads/torrent/incomplete";
      };
    };

    systemd.tmpfiles.settings = {
      "10-media" = {
        "/data/downloads/torrent/complete".d = {
          user = "media";
          group = "media";
          mode = "0775";
        };
        "/data/downloads/torrent/incomplete".d = {
          user = "media";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver = {
      services = {
        transmission.homepage.widget = {
          type = "transmission";
          url = "http://127.0.0.1:${toString cfg.port}";
          username = "{{HOMEPAGE_VAR_USERNAME}}";
          password = "{{HOMEPAGE_VAR_PASSWORD}}";
        };
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
