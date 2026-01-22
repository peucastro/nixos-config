{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.filebrowser;
in {
  options.homeserver.services.filebrowser = {
    enable = lib.mkEnableOption "Filebrowser web file manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "The TCP port on which Filebrowser will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "files.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Filebrowser.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Filebrowser";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Web file manager";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "filebrowser.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Utilities";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.filebrowser = {
      enable = true;
      settings = {
        inherit (cfg) port;
        root = "/";
      };
    };

    homeserver.caddy.vhosts = [{inherit (cfg) hostname port;}];
  };
}
