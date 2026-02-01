{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.loki;
  dataDir = config.services.loki.dataDir;
in {
  options.homeserver.services.loki = {
    enable = lib.mkEnableOption "Loki log aggregation system";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3100;
      description = "The TCP port on which Loki will listen internally.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.loki = {
      enable = true;
      configuration = {
        server.http_listen_port = cfg.port;
        auth_enabled = false;

        common = {
          path_prefix = dataDir;
          replication_factor = 1;
          storage.filesystem = {
            chunks_directory = "${dataDir}/chunks";
            rules_directory = "${dataDir}/rules";
          };
          ring.kvstore.store = "inmemory";
        };

        schema_config.configs = [
          {
            from = "2024-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
    };
  };
}
