{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.uptime-kuma;
in {
  options.homeserver.services.uptime-kuma = {
    enable = lib.mkEnableOption "Uptime Kuma monitoring";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
      description = "The TCP port on which the Uptime Kuma service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "uptime.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Uptime Kuma.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Uptime Kuma";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Self-hosted monitoring service";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "uptime-kuma.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings.PORT = toString cfg.port;
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
