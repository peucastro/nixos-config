{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.healthchecks;
in {
  options.homeserver.services.healthchecks = {
    enable = lib.mkEnableOption "Healthchecks uptime monitoring service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "The TCP port on which Healthchecks will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "health.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Healthchecks.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Healthchecks";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Uptime monitoring and alerts";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "healthchecks.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Monitoring";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for Healthchecks";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.healthchecks = {
      enable = true;
      listenAddress = "127.0.0.1";
      inherit (cfg) port;
      settings = {
        SECRET_KEY_FILE = config.age.secrets.healthchecks-api-key.path;
      };
    };

    environment.systemPackages = [pkgs.healthchecks];

    homeserver = {
      services = {
        healthchecks.homepage.widget = {
          type = "customapi";
          url = "http://127.0.0.1:${toString cfg.port}/api/v1/checks/";
          method = "GET";
          headers = {
            "X-Api-Key" = "{{HOMEPAGE_VAR_HEALTHCHECKS_API_KEY}}";
          };
          mappings = [
            {
              field = "checks";
              label = "Total Monitors";
              format = "size";
            }
            {
              field = "checks[0].status";
              label = "Primary Status";
            }
          ];
        };
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
