{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.linkwarden;
in {
  options.homeserver.services.linkwarden = {
    enable = lib.mkEnableOption "Linkwarden bookmark and archive manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3002;
      description = "The TCP port on which Linkwarden will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "links.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Linkwarden.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Linkwarden";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Bookmark manager and archive";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "linkwarden.png";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Utilities";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.linkwarden = {
      enable = true;
      inherit (cfg) port;
      host = "127.0.0.1";
      enableRegistration = true;
    };

    homeserver.services.backups.paths = [config.services.linkwarden.storageLocation];

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
