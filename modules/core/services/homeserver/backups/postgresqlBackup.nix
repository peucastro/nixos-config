{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.backups.postgresql;
in {
  options.homeserver.services.backups.postgresql = {
    enable = lib.mkEnableOption "Enable PostgreSQL backups";
    location = lib.mkOption {
      type = lib.types.path;
      default = "/var/backup/postgresql";
      description = "Directory to store the PostgreSQL backups";
    };
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of databases to back up (empty for all)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresqlBackup = {
      enable = true;
      inherit (cfg) location databases;
    };

    systemd.tmpfiles.settings = {
      "10-backups-postgres" = {
        "${cfg.location}".d = {
          user = "postgres";
          group = "postgres";
          mode = "0700";
        };
      };
    };
  };
}
