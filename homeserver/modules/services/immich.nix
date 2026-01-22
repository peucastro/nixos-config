{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.immich;
in {
  options.homeserver.services.immich = {
    enable = lib.mkEnableOption "Immich server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
      description = "The TCP port on which the Immich service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "photos.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Immich.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Immich";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Self-hosted photo management";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "immich.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) port;
      host = "127.0.0.1";
    };

    homeserver.services.backups.paths = [config.services.immich.mediaLocation];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
