{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.jellyseerr;
in {
  options.homeserver.services.jellyseerr = {
    enable = lib.mkEnableOption "Jellyseerr request manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "The TCP port on which the Jellyseerr service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "requests.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Jellyseerr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Jellyseerr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Media request and management for Jellyfin.";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "jellyseerr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      inherit (cfg) port;
    };

    systemd.services.jellyseerr.environment.HOST = "127.0.0.1";

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
