{
  config,
  lib,
  ...
}: {
  imports = [
    ./grafana.nix
    ./prometheus.nix
  ];

  options.homeserver.services.monitoring.enable = lib.mkEnableOption "Enable all monitoring services (Grafana and Prometheus)";

  config = lib.mkIf config.homeserver.services.monitoring.enable {
    homeserver.services = {
      grafana.enable = true;
      prometheus.enable = true;
    };
  };
}
