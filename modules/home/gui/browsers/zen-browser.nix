{
  pkgs,
  inputs,
  ...
}: let
  inherit (import ../desktop/colors.nix) colors;
in {
  imports = [inputs.zen-browser.homeModules.beta];

  programs.zen-browser = {
    enable = true;
    policies = let
      mkLockedAttrs = builtins.mapAttrs (_: value: {
        Value = value;
        Status = "locked";
      });

      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
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

      # Extensions
      ExtensionSettings = mkExtensionSettings {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "languagetool-webextension@languagetool.org" = "languagetool";
        "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
        "firefox@tampermonkey.net" = "tampermonkey";
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = "auto-tab-discard";
        "skipredirect@sblask" = "skip-redirect";
      };

      # UI / defaults
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      DisablePocket = true;

      Preferences = mkLockedAttrs {
        # General UI / usability
        "browser.tabs.warnOnClose" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.shell.checkDefaultBrowser" = false;

        # Search / address bar
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled" = false;

        # Privacy / tracking
        "network.cookie.cookieBehavior" = 1;
        "dom.battery.enabled" = false;
        "webgl.disabled" = true;

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
        "zen.view.compact.animate-sidebar" = false;
        "zen.view.show-newtab-button-top" = false;
      };

      spacesForce = true;
      spaces = {
        "Personal" = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
          position = 1000;
          icon = "👤";
        };
        "Work" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
          position = 2000;
          icon = "💼";
        };
        "College" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195c";
          position = 3000;
          icon = "📚";
        };
      };

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
            definedAliases = ["np"];
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
            definedAliases = ["hmop"];
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
