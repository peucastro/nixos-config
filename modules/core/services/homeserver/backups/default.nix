{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.backups;
in {
  imports = [
    ./postgresqlBackup.nix
    ./restic.nix
  ];

  options.homeserver.services.backups = {
    enable = lib.mkEnableOption "Enable backups (Restic and PostgreSQL)";
  };

  config = lib.mkIf cfg.enable {
    homeserver.services.backups.restic.enable = lib.mkDefault true;
    homeserver.services.backups.postgresql.enable = lib.mkDefault true;
  };
}
