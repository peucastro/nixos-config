{
  config,
  secrets,
  ...
}: {
  age.secrets = {
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
    lidarr-api-key = {
      file = "${secrets}/lidarr-api-key.age";
      mode = "0400";
      owner = config.services.lidarr.user;
      group = config.services.lidarr.group;
    };
    linkwarden-env = {
      file = "${secrets}/linkwarden-env.age";
      mode = "0400";
      owner = "linkwarden";
      group = "linkwarden";
    };
    soulseek-env = {
      file = "${secrets}/soulseek-env.age";
      mode = "0400";
      owner = config.services.slskd.user;
      group = config.services.slskd.group;
    };
  };
}
