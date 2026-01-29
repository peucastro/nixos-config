{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.stirling-pdf;
in {
  options.homeserver.services.stirling-pdf = {
    enable = lib.mkEnableOption "Stirling-PDF - PDF manipulation tool";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8084;
      description = "The TCP port on which Stirling-PDF will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "pdf.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Stirling-PDF.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Stirling PDF";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "PDF manipulation and conversion tool";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "stirling-pdf.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Utilities";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.stirling-pdf = {
      enable = true;
      environment = {
        SERVER_PORT = cfg.port;

        SECURITY_ENABLELOGIN = "true";
        SECURITY_INITIALLOGIN_USERNAME = "admin";
        SECURITY_INITIALLOGIN_PASSWORD = "admin";

        LANGS = "en_US,pt_PT";
        SYSTEM_DEFAULTLOCALE = "en_US";

        SYSTEM_ENABLEANALYTICS = "false";
      };
    };

    homeserver.services.backups.paths = ["/var/lib/stirling-pdf"];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
