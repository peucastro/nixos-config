{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.bazarr;
in {
  options.homeserver.services.bazarr = {
    enable = lib.mkEnableOption "Bazarr subtitle manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 6767;
      description = "The TCP port on which the Bazarr Web UI will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "captions.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Bazarr.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Bazarr";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Subtitle management for Radarr/Sonarr";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "bazarr.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Servarr";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      listenPort = cfg.port;
      group = "media";
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
