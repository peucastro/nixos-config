{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.glances;
in {
  options.homeserver.services.glances = {
    enable = lib.mkEnableOption "Glances system monitor";

    port = lib.mkOption {
      type = lib.types.port;
      default = 61208;
      description = "The TCP port on which the Glances service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "glances.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Glances.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Glances";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "System monitoring web UI";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "glances.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.glances = {
      enable = true;
      inherit (cfg) port;
      extraArgs = ["--webserver" "--bind" "127.0.0.1"];
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
