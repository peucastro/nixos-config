{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.navidrome;
in {
  options.homeserver.services.navidrome = {
    enable = lib.mkEnableOption "Navidrome music streaming server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 4533;
      description = "The TCP port on which Navidrome will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "navidrome.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access Navidrome.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Navidrome";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Modern music server and streamer";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "navidrome.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Media";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      group = "media";
      settings = {
        Port = cfg.port;
        MusicFolder = "/data/media/music";
      };
    };

    homeserver = {
      services.backups.restic.paths = ["/var/lib/navidrome"];
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
