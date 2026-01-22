{
  config,
  lib,
  pkgs,
  ...
}: {
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
}
