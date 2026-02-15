{
  pkgs,
  inputs,
  ...
}: let
  inherit (import ../desktop/colors.nix) colors;
in {
  imports = [inputs.zen-browser.homeModules.twilight];

  programs.zen-browser = {
    enable = true;

    # Browser policies
    policies = let
      mkLockedAttrs = builtins.mapAttrs (_: value: {
        Value = value;
        Status = "locked";
      });
    in {
      # Autofill / form behavior
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      # Updates / studies / telemetry
      DisableAppUpdate = false;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisableFeedbackCommands = true;

      # Sync / Accounts
      DisableFirefoxAccounts = true;

      # Content, privacy & tracking protection
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # Cookies / storage
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        Locked = true;
      };

      # HTTPS
      HttpsOnlyMode = "force_enabled";

      # UI / defaults
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      DisablePocket = true;

      # Preferences
      Preferences = mkLockedAttrs {
        # General UI / usability
        "browser.tabs.warnOnClose" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.shell.checkDefaultBrowser" = false;
        "gfx.webrender.all" = true;
        "widget.dmabuf.force-enabled" = true;

        # Search / address bar
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled" = false;

        # Privacy / tracking
        "network.cookie.cookieBehavior" = 1;
        "dom.battery.enabled" = false;

        # Referrer policy
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # Security
        "dom.security.https_only_mode" = true;

        # Telemetry / studies
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Passwords / signon
        "signon.rememberSignons" = false;

        # Disable risky features
        "extensions.translations.disabled" = true;
        "media.peerconnection.ice.default_address_only" = true;
      };
    };

    # Default profile
    profiles."default" = {
      settings = {
        "zen.mods.auto-update" = false;
        "zen.widget.linux.transparency" = true;
        "zen.tabs.vertical.right-side" = true;
        "zen.theme.accent-color" = "#${colors.focused}";
        "zen.watermark.enabled" = false;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.animate-sidebar" = true;
        "zen.view.show-newtab-button-top" = false;
      };

      # Extensions via rycee’s firefox-addons
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        bitwarden
        clearurls
        auto-tab-discard
        skip-redirect
        refined-github
      ];

      search = {
        force = true;
        default = "ddg";
        engines = let
          nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        in {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = ["nop"];
          };
          "Home Manager Options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = ["@hmop"];
          };
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "default-web-browser" = ["zen-beta.desktop"];
    "x-scheme-handler/http" = ["zen-beta.desktop"];
    "x-scheme-handler/https" = ["zen-beta.desktop"];
  };
}
