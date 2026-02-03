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
      environmentFile = config.age.secrets.homepage-env.path;
      settings = {
        title = "Home server";
        description = "My Personal Home server";
        color = "neutral";
        favicon = "https://nixos.org/favicon.svg";
        disableCollapse = true;
        quicklaunch = {
          searchDescriptions = true;
          showSearchSuggestions = true;
          provider = "duckduckgo";
        };
        disableIndexing = true;
        hideVersion = true;
        disableUpdateCheck = true;
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
            (x: let
              serviceCfg = config.homeserver.services.${x};
              hasWidget = serviceCfg.homepage ? widget && serviceCfg.homepage.widget ? type;
            in {
              "${serviceCfg.homepage.name}" =
                {
                  icon = serviceCfg.homepage.icon;
                  description = serviceCfg.homepage.description;
                  href = "https://${serviceCfg.hostname}";

                  siteMonitor = "http://127.0.0.1:${toString serviceCfg.port}";
                  statusStyle = "dot";
                }
                // (lib.optionalAttrs hasWidget {
                  widget = serviceCfg.homepage.widget;
                });
            });
        });
    };

    users = {
      users.homepage-dashboard = {
        isSystemUser = true;
        group = "homepage-dashboard";
      };
      groups.homepage-dashboard = {};
    };

    systemd.services.homepage-dashboard.serviceConfig = {
      User = "homepage-dashboard";
      Group = "homepage-dashboard";
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
