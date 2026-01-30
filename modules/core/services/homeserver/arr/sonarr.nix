{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.sonarr;
in {
  options.homeserver.services.sonarr = {
    enable = lib.mkEnableOption "Sonarr TV show manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8989;
      description = "The TCP port on which the Sonarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "shows.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Sonarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Sonarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "TV show collection manager for Usenet and BitTorrent";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "sonarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for Sonarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      settings.server = {
        inherit (cfg) port;
        bindAddress = "127.0.0.1";
      };
      group = "media";
      environmentFiles = [config.age.secrets.sonarr-api-key.path];
    };

    systemd.tmpfiles.settings = {
      "20-media" = {
        "/data/media/shows".d = {
          user = "sonarr";
          group = "media";
          mode = "0775";
        };
      };
    };

    homeserver = {
      services = {
        sonarr.homepage.widget = {
          type = "sonarr";
          url = "http://127.0.0.1:${toString cfg.port}";
          key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
          enableQueue = true;
        };
        backups.paths = [config.services.sonarr.dataDir];
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
