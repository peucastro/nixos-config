{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.tunnels;
in {
  options.homeserver.tunnels = {
    enable = lib.mkEnableOption "Cloudflare Tunnels";
    tunnels = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          credentialsFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to the Cloudflare Tunnel credentials file (JSON).";
          };
          ingress = lib.mkOption {
            type = lib.types.attrs;
            description = "Ingress rules for this tunnel.";
          };
          default = lib.mkOption {
            type = lib.types.str;
            default = "http_status:404";
            description = "Default action for unmatched ingress.";
          };
        };
      });
      default = {};
      description = "Cloudflare tunnels to configure.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels =
        lib.mapAttrs (
          name: tunnel: {
            inherit (tunnel) credentialsFile default;
            ingress =
              tunnel.ingress
              // {
                "default" = tunnel.default;
              };
          }
        )
        cfg.tunnels;
    };

    environment.systemPackages = [pkgs.cloudflared];
  };
}
