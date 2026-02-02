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
    homepage-env = {
      file = "${secrets}/homepage_env.age";
      mode = "0400";
      owner = "homepage-dashboard";
      group = "homepage-dashboard";
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
    prowlarr-api-key = {
      file = "${secrets}/prowlarr-api-key.age";
      mode = "0440";
      owner = "prowlarr";
      group = "prowlarr";
    };
    soulseek-env = {
      file = "${secrets}/soulseek-env.age";
      mode = "0400";
      owner = config.services.slskd.user;
      group = config.services.slskd.group;
    };
    miniflux-env = {
      file = "${secrets}/miniflux-env.age";
      mode = "0400";
      owner = "miniflux";
      group = "miniflux";
    };
    backblaze-api-key = {
      file = "${secrets}/backblaze-api-key.age";
      mode = "0400";
      owner = "root";
      group = "root";
    };
    healthchecks-api-key = {
      file = "${secrets}/healthchecks-api-key.age";
      mode = "0400";
      owner = config.services.healthchecks.user;
      group = config.services.healthchecks.group;
    };
  };
}
