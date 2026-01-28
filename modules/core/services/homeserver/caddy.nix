{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.caddy;
in {
  options.homeserver.services.caddy = {
    enable = lib.mkEnableOption "Caddy reverse proxy";
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy-env.path;

      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
        hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg=";
      };

      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      '';

      virtualHosts = lib.listToAttrs (map
        (v: let
          inherit (v) hostname port;
        in {
          name = hostname;
          value.extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString port}
          '';
        })
        config.homeserver.caddy.vhosts);
    };

    networking.firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [443];
    };

    homeserver.services.backups.paths = [config.services.caddy.dataDir];
  };
}
