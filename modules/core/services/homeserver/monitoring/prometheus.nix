{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.prometheus;
in {
  options.homeserver.services.prometheus = {
    enable = lib.mkEnableOption "Prometheus monitoring system";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "The TCP port on which Prometheus will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "prometheus.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Prometheus.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Prometheus";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Metrics collection and alerting";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "prometheus.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for Prometheus.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      inherit (cfg) port;

      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd" "diskstats" "netdev"];
          port = 9100;
        };

        smartctl = {
          enable = true;
          port = 9633;
        };

        restic = {
          enable = true;
          port = 9753;
          passwordFile = config.homeserver.services.backups.restic.passwordFile;
          repository = config.homeserver.services.backups.restic.targets.local.repository;
          refreshInterval = 43200;
          user = "root";
          group = "root";
        };
      };

      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString cfg.port}"];
            }
          ];
        }
        {
          job_name = "node";
          static_configs = [
            {
              targets = ["127.0.0.1:9100"];
            }
          ];
        }
        {
          job_name = "caddy";
          static_configs = [
            {
              targets = ["127.0.0.1:2019"];
            }
          ];
        }
        {
          job_name = "smartctl";
          static_configs = [
            {
              targets = ["127.0.0.1:9633"];
            }
          ];
        }
        {
          job_name = "restic";
          static_configs = [
            {
              targets = ["127.0.0.1:9753"];
            }
          ];
        }
      ];
    };

    services.smartd.enable = true;

    homeserver = {
      services = {
        prometheus.homepage.widget = {
          type = "prometheus";
          url = "http://127.0.0.1:${toString cfg.port}";
        };
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
