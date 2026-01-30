{
  config,
  lib,
  ...
}: {
  imports = [
    ./alloy.nix
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
  ];

  options.homeserver.services.monitoring.enable = lib.mkEnableOption "Enable all monitoring services (Grafana, Prometheus, Loki, Alloy)";

  config = lib.mkIf config.homeserver.services.monitoring.enable {
    homeserver.services.grafana.enable = true;
    homeserver.services.prometheus.enable = true;
    homeserver.services.loki.enable = true;
    homeserver.services.alloy.enable = true;
  };
}
