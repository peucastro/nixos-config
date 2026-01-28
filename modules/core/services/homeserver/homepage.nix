{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.homepage;

  homepageCategories = ["Media" "Servarr" "Downloads" "Monitoring" "Network" "Utilities"];

  homepageServices = category: (lib.attrsets.filterAttrs
    (_name: value: value.enable or false && value ? homepage && value.homepage.category == category)
    config.homeserver.services);
in {
  options.homeserver.services.homepage = {
    enable = lib.mkEnableOption "Homepage dashboard";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "The TCP port on which the Homepage dashboard service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "home.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access the Homepage dashboard.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Homepage";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Application dashboard.";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "homepage.png";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Utilities";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = cfg.port;
      settings = {
        title = "Home server";
        description = "My Personal Home server";
        color = "neutral";
        headerStyle = "boxedWidgets";
        layout = [
          {
            Glances = {
              header = true;
              style = "row";
              columns = 4;
            };
          }
        ];
      };
      allowedHosts = "localhost:${toString cfg.port},127.0.0.1:${toString cfg.port},${toString cfg.hostname}";
      services =
        [
          {
            Glances = let
              baseUrl = "http://127.0.0.1:";
              port = toString config.homeserver.services.glances.port;
            in [
              {
                Info = {
                  widget = {
                    type = "glances";
                    url = "${baseUrl}${port}";
                    metric = "info";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                "CPU Temp" = {
                  widget = {
                    type = "glances";
                    url = "${baseUrl}${port}";
                    metric = "sensor:Package id 0";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                Processes = {
                  widget = {
                    type = "glances";
                    url = "${baseUrl}${port}";
                    metric = "process";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                Network = {
                  widget = {
                    type = "glances";
                    url = "${baseUrl}${port}";
                    metric = "network:enp2s0";
                    chart = false;
                    version = 4;
                  };
                };
              }
            ];
          }
        ]
        ++ lib.lists.forEach homepageCategories (cat: {
          "${cat}" =
            lib.lists.forEach
            (lib.attrsets.mapAttrsToList (name: _value: name) (homepageServices "${cat}"))
            (x: {
              "${config.homeserver.services.${x}.homepage.name}" = {
                icon = config.homeserver.services.${x}.homepage.icon;
                description = config.homeserver.services.${x}.homepage.description;
                href = "https://${config.homeserver.services.${x}.hostname}";
              };
            });
        });
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
