{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.grafana;
  prometheusPort = config.homeserver.services.prometheus.port;
  lokiPort = config.homeserver.services.loki.port;
in {
  options.homeserver.services.grafana = {
    enable = lib.mkEnableOption "Grafana analytics and monitoring platform";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3004;
      description = "The TCP port on which Grafana will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "grafana.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Grafana.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Grafana";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Analytics and monitoring dashboards";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "grafana.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server.http_port = cfg.port;
      provision = {
        enable = true;
        datasources.settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString prometheusPort}";
              access = "proxy";
              isDefault = true;
              editable = false;
            }
            {
              name = "Loki";
              type = "loki";
              url = "http://127.0.0.1:${toString lokiPort}";
              access = "proxy";
              editable = false;
            }
          ];
        };
        dashboards.settings.providers = [
          {
            name = "Default";
            options.path = "/etc/grafana-dashboards";
          }
        ];
      };
    };

    environment.etc = {
      "grafana-dashboards/node-exporter.json" = {
        source = pkgs.fetchurl {
          url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
          hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
        };
        group = "grafana";
        user = "grafana";
      };
      "grafana-dashboards/caddy.json" = {
        source = pkgs.fetchurl {
          url = "https://grafana.com/api/dashboards/20802/revisions/1/download";
          hash = "sha256-vSt63PakGp5NzKFjbU5Yh0nDbKET5QRWp5nusM76/O4=";
        };
        group = "grafana";
        user = "grafana";
      };
    };

    homeserver.services.backups.paths = [config.services.grafana.dataDir];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
