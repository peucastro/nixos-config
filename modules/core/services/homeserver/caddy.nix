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
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
        hash = "sha256-J0HWjCPoOoARAxDpG2bS9c0x5Wv4Q23qWZbTjd8nW84=";
      };

      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        admin 127.0.0.1:2019
        servers {
          metrics
        }
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
  };
}
