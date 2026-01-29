{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.calibre-web;
in {
  options.homeserver.services.calibre-web = {
    enable = lib.mkEnableOption "Calibre-Web ebook library manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8083;
      description = "The TCP port on which Calibre-Web will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "books.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Calibre-Web.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Calibre-Web";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Ebook library manager and reader";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "calibre-web.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
      listen = {
        ip = "127.0.0.1";
        inherit (cfg) port;
      };
      group = "media";
      options = {
        calibreLibrary = "/data/media/books";
        enableBookUploading = true;
        enableBookConversion = true;
        enableKepubify = true;
        reverseProxyAuth.enable = false;
      };
    };

    users.users.calibre-web = {
      isSystemUser = true;
      group = "media";
    };

    systemd.tmpfiles.settings = {
      "10-media" = {
        "/data/media/books".d = {
          user = "media";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver.services.backups.paths = [config.services.calibre-web.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
