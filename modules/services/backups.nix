{
  config,
  lib,
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
    repository = lib.mkOption {
      type = lib.types.str;
      description = "Restic repository (local path or remote URL)";
    };
    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "File containing the Restic repository password";
    };
    timer = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "systemd timer frequency (e.g., daily, weekly)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.restic.backups = {
      local = {
        inherit (cfg) repository passwordFile paths;
        timerConfig = {
          OnCalendar = cfg.timer;
          Persistent = true;
        };
        initialize = true;
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 3"
          "--keep-monthly 2"
        ];
      };
    };
  };
}
