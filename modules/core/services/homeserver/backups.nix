{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.backups;
in {
  options.homeserver.services.backups = {
    enable = lib.mkEnableOption "Enable Restic backups";
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of folders to back up";
      default = [];
    };
    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "The shared encryption password for all repos";
    };
    targets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          repository = lib.mkOption {type = lib.types.str;};
          environmentFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
          };
          timer = lib.mkOption {
            type = lib.types.str;
            default = "daily";
          };
          healthchecksId = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      });
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    services.restic.backups =
      lib.mapAttrs (name: target: {
        inherit (cfg) paths passwordFile;
        inherit (target) repository environmentFile;

        initialize = true;
        timerConfig = {
          OnCalendar = target.timer;
          Persistent = true;
        };

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 3"
          "--keep-monthly 2"
        ];

        backupCleanupCommand = lib.optionalString (target.healthchecksId != null) ''
          UUID="${target.healthchecksId}"
          BASE_URL="http://localhost:${toString config.services.healthchecks.port}"

          if [ "$EXIT_STATUS" = "0" ]; then
            ${pkgs.curl}/bin/curl -m 10 --retry 5 "$BASE_URL/ping/$UUID"
          else
            ${pkgs.curl}/bin/curl -m 10 --retry 5 "$BASE_URL/ping/$UUID/fail"
          fi
        '';
      })
      cfg.targets;

    environment.systemPackages = [pkgs.restic];
  };
}
