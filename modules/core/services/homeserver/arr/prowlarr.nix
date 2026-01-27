{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.prowlarr;
in {
  options.homeserver.services.prowlarr = {
    enable = lib.mkEnableOption "Prowlarr indexer manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9696;
      description = "The TCP port on which the Prowlarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "trackers.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Prowlarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Prowlarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Indexer manager for Usenet and BitTorrent";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "prowlarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      settings.server = {
        inherit (cfg) port;
        bindAddress = "127.0.0.1";
      };
    };

    homeserver.services.backups.paths = [config.services.prowlarr.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
