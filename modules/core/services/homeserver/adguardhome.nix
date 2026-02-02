{
  config,
  lib,
  ...
}: let
  cfg = config.homeserver.services.adguardhome;
  inherit (config.homeserver) lanIp;
in {
  options.homeserver.services.adguardhome = {
    enable = lib.mkEnableOption "Network-wide ads & trackers blocking DNS server.";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "The TCP port on which the AdGuard Home service will listen internally.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "dns.${config.homeserver.baseDomain}";
      description = "The public DNS hostname used to access AdGuard Home.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "AdGuard Home";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "DNS server with ad/tracker blocking and web UI";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "adguard-home.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Network";
      };
      widget = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Homepage widget configuration for AdGuard Home";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      inherit (cfg) port;
      mutableSettings = false;
      settings = {
        http = {
          pprof = {
            port = 6060;
            enabled = false;
          };
          address = "0.0.0.0:${cfg.port}";
          session_ttl = "720h";
        };
        users = [];
        auth_attempts = 5;
        block_auth_min = 15;
        http_proxy = "";
        language = "";
        theme = "dark";
        dns = {
          bind_hosts = ["0.0.0.0"];
          port = 53;
          anonymize_client_ip = false;
          ratelimit = 20;
          ratelimit_subnet_len_ipv4 = 24;
          ratelimit_subnet_len_ipv6 = 56;
          ratelimit_whitelist = [];
          refuse_any = true;
          upstream_dns = ["127.0.0.1:5335"];
          upstream_dns_file = "";
          bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
          fallback_dns = ["1.1.1.1" "8.8.8.8"];
          upstream_mode = "parallel";
          fastest_timeout = "1s";
          allowed_clients = [];
          disallowed_clients = [];
          blocked_hosts = ["version.bind" "id.server" "hostname.bind"];
          trusted_proxies = ["127.0.0.0/8" "::1/128"];
          cache_enabled = true;
          cache_size = 4194304;
          cache_ttl_min = 60;
          cache_ttl_max = 86400;
          cache_optimistic = true;
          bogus_nxdomain = [];
          aaaa_disabled = false;
          enable_dnssec = false;
          edns_client_subnet = {
            custom_ip = "";
            enabled = false;
            use_custom = false;
          };
          max_goroutines = 300;
          handle_ddr = true;
          ipset = [];
          ipset_file = "";
          bootstrap_prefer_ipv6 = false;
          upstream_timeout = "10s";
          private_networks = [];
          use_private_ptr_resolvers = true;
          local_ptr_upstreams = [];
          use_dns64 = false;
          dns64_prefixes = [];
          serve_http3 = false;
          use_http3_upstreams = false;
          serve_plain_dns = true;
          hostsfile_enabled = true;
          pending_requests = {
            enabled = true;
          };
        };
        tls = {
          enabled = false;
          server_name = "";
          force_https = false;
          port_https = 443;
          port_dns_over_tls = 853;
          port_dns_over_quic = 853;
          port_dnscrypt = 0;
          dnscrypt_config_file = "";
          allow_unencrypted_doh = false;
          certificate_chain = "";
          private_key = "";
          certificate_path = "";
          private_key_path = "";
          strict_sni_check = false;
        };
        querylog = {
          dir_path = "";
          ignored = [];
          interval = "2160h";
          size_memory = 1000;
          enabled = true;
          file_enabled = true;
        };
        statistics = {
          dir_path = "";
          ignored = [];
          interval = "2160h";
          enabled = true;
        };
        filters = [
          {
            enabled = true;
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            name = "AdGuard DNS filter";
            id = 1;
          }
          {
            enabled = true;
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
            name = "AdAway Default Blocklist";
            id = 2;
          }
          {
            enabled = true;
            url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt";
            name = "HaGeZi's Pro Blocklist";
            id = 3;
          }
        ];
        whitelist_filters = [];
        user_rules = [];
        dhcp = {
          enabled = false;
          interface_name = "";
          local_domain_name = "lan";
          dhcpv4 = {
            gateway_ip = "";
            subnet_mask = "";
            range_start = "";
            range_end = "";
            lease_duration = 86400;
            icmp_timeout_msec = 1000;
            options = [];
          };
          dhcpv6 = {
            range_start = "";
            lease_duration = 86400;
            ra_slaac_only = false;
            ra_allow_slaac = false;
          };
        };
        filtering = {
          blocking_ipv4 = "";
          blocking_ipv6 = "";
          blocked_services = {
            schedule = {
              time_zone = "Local";
            };
            ids = [];
          };
          protection_disabled_until = null;
          safe_search = {
            enabled = false;
            bing = true;
            duckduckgo = true;
            ecosia = true;
            google = true;
            pixabay = true;
            yandex = true;
            youtube = true;
          };
          blocking_mode = "default";
          parental_block_host = "family-block.dns.adguard.com";
          safebrowsing_block_host = "standard-block.dns.adguard.com";
          rewrites =
            map (v: {
              domain = v.hostname;
              answer = lanIp;
              enabled = true;
            })
            config.homeserver.caddy.vhosts;
          safe_fs_patterns = [];
          safebrowsing_cache_size = 1048576;
          safesearch_cache_size = 1048576;
          parental_cache_size = 1048576;
          cache_time = 30;
          filters_update_interval = 12;
          blocked_response_ttl = 10;
          filtering_enabled = true;
          rewrites_enabled = true;
          parental_enabled = false;
          safebrowsing_enabled = false;
          protection_enabled = true;
        };
        clients = {
          runtime_sources = {
            whois = true;
            arp = true;
            rdns = true;
            dhcp = true;
            hosts = true;
          };
          persistent = [];
        };
        log = {
          enabled = true;
          file = "";
          max_backups = 10;
          max_size = 100;
          max_age = 30;
          compress = false;
          local_time = false;
          verbose = false;
        };
        os = {
          group = "";
          user = "";
          rlimit_nofile = 0;
        };
        schema_version = 31;
      };
    };

    services.unbound = {
      enable = true;
      checkconf = true;
      settings = {
        server = {
          # Network interface
          interface = ["127.0.0.1"];
          port = 5335;
          access-control = ["127.0.0.0/8 allow"];
          do-not-query-localhost = false;

          # Performance - prefetching
          prefetch = true;
          prefetch-key = true;

          # Privacy
          hide-identity = true;
          hide-version = true;

          # Cache settings
          cache-min-ttl = 300;
          cache-max-ttl = 86400;
          msg-cache-size = "32m";
          rrset-cache-size = "64m";
          key-cache-size = "16m";
          neg-cache-size = "4m";

          # Unwanted reply threshold for detecting DNS poisoning
          unwanted-reply-threshold = 10000000;

          # Private address ranges (RFC1918) - prevent DNS rebinding
          private-address = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "169.254.0.0/16"
            "fd00::/8"
            "fe80::/10"
          ];
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [53 3000];
      allowedUDPPorts = [53];
    };

    homeserver = {
      services.adguardhome.homepage.widget = {
        type = "adguard";
        url = "http://127.0.0.1:${toString cfg.port}";
        username = "{{HOMEPAGE_VAR_USERNAME}}";
        password = "{{HOMEPAGE_VAR_PASSWORD}}";
      };
      caddy.vhosts = [{inherit (cfg) hostname port;}];
    };
  };
}
