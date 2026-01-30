{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.alloy;
  lokiPort = config.homeserver.services.loki.port;

  alloyConfig = pkgs.writeText "config.alloy" ''
    loki.relabel "journal_labels" {
      forward_to = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
    }

    loki.source.journal "read" {
      forward_to    = [loki.write.local_loki.receiver]
      relabel_rules = loki.relabel.journal_labels.rules
      labels        = { host = "${config.networking.hostName}", job = "systemd-journal" }
    }

    loki.write "local_loki" {
      endpoint {
        url = "http://127.0.0.1:${toString lokiPort}/loki/api/v1/push"
      }
    }
  '';
in {
  options.homeserver.services.alloy = {
    enable = lib.mkEnableOption "Alloy log collection agent";
  };

  config = lib.mkIf cfg.enable {
    services.alloy = {
      enable = true;
      configPath = alloyConfig;
    };

    users.users.alloy = {
      isNormalUser = true;
      extraGroups = ["systemd-journal"];
    };
  };
}
