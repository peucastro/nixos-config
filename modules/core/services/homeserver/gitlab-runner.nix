{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeserver.services.gitlab-runner;
in {
  options.homeserver.services.gitlab-runner = {
    enable = lib.mkEnableOption "GitLab CI/CD runner";

    gitlabUrl = lib.mkOption {
      type = lib.types.str;
      description = "GitLab instance URL";
      example = "https://gitlab.com";
    };

    authenticationTokenFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to file containing the GitLab runner authentication token";
    };

    concurrent = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Maximum number of concurrent jobs";
    };

    runUntagged = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to run jobs that have no tags";
    };

    tagList = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of tags for this runner";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages to install for runner jobs";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitlab-runner = {
      enable = true;
      inherit (cfg) concurrent;
      inherit (cfg) extraPackages;

      services = {
        runner = {
          executor = "shell";
          inherit (cfg) runUntagged;
          inherit (cfg) tagList;
          authenticationTokenConfigFile = pkgs.writeText "gitlab-runner-auth.toml" ''
            url = "${cfg.gitlabUrl}"
            authentication_token = <<EOF
            ${builtins.readFile cfg.authenticationTokenFile}
            EOF
            executor = "shell"
            run-untagged = ${
              if cfg.runUntagged
              then "true"
              else "false"
            }
            tag-list = ${lib.concatStringsSep "," cfg.tagList}
            output-limit = 16384
            shell = "bash"
          '';
        };
      };
    };
  };
}
