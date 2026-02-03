{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.readarr;
in {
  options.homeserver.services.readarr = {
    enable = lib.mkEnableOption "Readarr ebook and audiobook manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8787;
      description = "The TCP port on which the Readarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "books.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Readarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Readarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Ebook and audiobook collection manager for Usenet and BitTorrent";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "readarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.readarr = {
      enable = true;
      group = "media";
      settings.server = {
        inherit (cfg) port;
        bindAddress = "127.0.0.1";
      };
    };

    systemd.tmpfiles.settings = {
      "20-media" = {
        "/data/media/books".d = {
          user = "readarr";
          group = "media";
          mode = "0775";
        };
        "/data/media/audiobooks".d = {
          user = "readarr";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver = {
      services.backups.restic.paths = [config.services.readarr.dataDir];
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
