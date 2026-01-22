{
  agenix,
  secrets,
  config,
  ...
}: {
  imports = [agenix.nixosModules.default];

  age = {
    identityPaths = [
      "/etc/ssh/agenix_shared_key"
      "/etc/ssh/agenix_recovery_key"
    ];

    secrets = {
      homeserver = {
        file = "${secrets}/homeserver.age";
        path = "/home/homeserver/.ssh/homeserver";
        symlink = true;
        mode = "0400";
        owner = "homeserver";
        group = "users";
      };
      caddy-env = {
        file = "${secrets}/caddy_env.age";
        mode = "0400";
        owner = "caddy";
        group = "caddy";
      };
      deluge-auth = {
        file = "${secrets}/deluge-auth.age";
        mode = "0400";
        owner = config.services.deluge.user;
        group = config.services.deluge.group;
      };
      radarr-api-key = {
        file = "${secrets}/radarr-api-key.age";
        mode = "0400";
        owner = config.services.radarr.user;
        group = config.services.radarr.group;
      };
      sonarr-api-key = {
        file = "${secrets}/sonarr-api-key.age";
        mode = "0400";
        owner = config.services.sonarr.user;
        group = config.services.sonarr.group;
      };
    };
  };
}
