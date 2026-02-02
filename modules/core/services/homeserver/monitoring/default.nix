{
  config,
  lib,
  ...
}: {
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./healthchecks.nix
  ];

  options.homeserver.services.monitoring.enable = lib.mkEnableOption "Enable all monitoring services (Grafana, Prometheus and Healthchecks)";

  config = lib.mkIf config.homeserver.services.monitoring.enable {
    homeserver.services = {
      grafana.enable = true;
      prometheus.enable = true;
      healthchecks.enable = true;
    };
  };
}
