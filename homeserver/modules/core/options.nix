{lib, ...}: {
  options.homeserver = {
    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "peucastro.me";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/New_York";
      description = "The system time zone.";
    };

    lanIp = lib.mkOption {
      type = lib.types.str;
      description = "The LAN IP address of this host for local DNS rewrites and service discovery.";
    };

    caddy.vhosts = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      default = [];
      description = "Reverse proxies exported by services for Caddy.";
    };
  };
}
