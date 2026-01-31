{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.miniflux;
in {
  options.homeserver.services.miniflux = {
    enable = lib.mkEnableOption "Miniflux RSS reader";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8085;
      description = "The TCP port on which Miniflux will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "rss.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Miniflux.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Miniflux";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Minimalist and opinionated feed reader";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "miniflux.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Utilities";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux-env.path;
      config.LISTEN_ADDR = "127.0.0.1:${toString cfg.port}";
    };

    users = {
      users.miniflux = {
        isSystemUser = true;
        group = "miniflux";
      };
      groups.miniflux = {};
    };

    systemd.services.miniflux.serviceConfig = {
      User = "miniflux";
      Group = "miniflux";
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
