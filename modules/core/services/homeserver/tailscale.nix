{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.tailscale;
in {
  options.homeserver.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
    };

    networking.firewall.trustedInterfaces = ["tailscale0"];
  };
}
