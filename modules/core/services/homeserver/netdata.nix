{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.netdata;
in {
  options.homeserver.services.netdata = {
    enable = lib.mkEnableOption "Netdata real-time system monitoring";

    port = lib.mkOption {
      type = lib.types.port;
      default = 19999;
      description = "The TCP port on which Netdata will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "metrics.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Netdata.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Netdata";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Real-time system monitoring and performance metrics";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "netdata.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.netdata = {
      enable = true;
      enableAnalyticsReporting = false;
      python.recommendedPythonPackages = true;
      config = {
        global = {
          "default port" = toString cfg.port;
        };
        web = {
          "bind to" = "127.0.0.1";
        };
        "plugin:freeipmi" = {
          "update every" = "never";
        };
        "plugins" = {
          "freeipmi" = "no";
        };
        "plugin:go.d" = {
          "postgres" = "no";
          "maxscale" = "no";
        };
      };
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
