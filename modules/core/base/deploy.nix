{
  pkgs,
  user,
  ...
}: let
  name = "deploy";
  version = "1.0.0";
  pname = "peucastro-nixos-config-${name}";

  deploy = pkgs.writeShellApplication {
    inherit name;
    meta = {
      description = "Deplout NixOS system with Git synchronization";
      license = pkgs.lib.licenses.mit;
    };

    derivationArgs = {
      inherit pname version;
      name = "${pname}-${version}";
    };

    runtimeInputs = [
      pkgs.git
      pkgs.libnotify
      pkgs.yq-go
    ];

    text = ''
      set -e
      HOST="$(hostname)"

      parse_options() {
        opts="$(getopt -n ${name} -o h -l help -o f -l force -- "$@")"
        eval set -- "$opts"
        REBUILD_FORCE=false
        FLAKE_HOST=""
        SSH_TARGET=""
        while true; do
          case "$1" in
            -h|--help)
              echo "Usage: ${name} [OPTIONS] [FLAKE_HOST] [SSH_HOST]"
              echo
              echo "Deploying NixOS system with Git synchronization."
              echo
              echo "Options:"
              echo "  -h, --help     Show this help message and exit."
              echo "  -f, --force    Force reploy, even if there are no changes to commit."
              echo
              echo "Arguments:"
              echo "  FLAKE_HOST     Flake hostname (e.g., kim)"
              echo "  SSH_HOST       SSH target (e.g., homeserver@192.168.1.100)"
              echo
              echo "Examples:"
              echo "  ${name}                                          # Local deploy"
              echo "  ${name} kim homeserver@192.168.1.100             # Remote deploy"
              echo
              exit 0
              ;;
            -f|--force)
              shift
              REBUILD_FORCE=true
              ;;
            --)
              shift
              FLAKE_HOST="''${1:-}"
              SSH_TARGET="''${2:-}"
              break
              ;;
            *)
              echo "Invalid option: $1"
              exit 1
              ;;
          esac
        done
      }

      format_files() {
        nix fmt . &> /dev/null || nix fmt .
        git add .
      }

      should_rebuild() {
        last_built_commit=$(git rev-parse --verify --quiet "$HOST^{}" || echo "<not-found>")
        current_commit=$(git rev-parse HEAD)
        if [ "$REBUILD_FORCE" == "true" ]; then
          return 0
        fi
        if [ "$last_built_commit" == "$current_commit" ] && git diff --staged --quiet; then
          echo "No new changes detected, exiting."
          echo
          return 1
        fi
        return 0
      }

      commit_and_push() {
        message=$(nixos-rebuild list-generations --json | yq -p=json ".[] | select(.current == true) | \"rebuild($HOST): generation \\(.generation), NixOS \\(.nixosVersion) with Linux Kernel \\(.kernelVersion)\"")
        git commit -m "$message" || true
        git push
      }

      notify_success() {
        notify-send -e "NixOS successfully rebuilt!" --icon=software-update-available
      }

      notify_failure() {
        notify-send -e "NixOS deploy failed!" --icon=dialog-error
      }

      parse_options "$@"
      pushd ~/nixos-config > /dev/null

      git stash
      git pull --rebase
      git stash pop || true

      format_files
      if ! should_rebuild; then
        popd > /dev/null
        exit 0
      fi
      echo "Deploying NixOS system..."

      if [ -z "$FLAKE_HOST" ]; then
        REBUILD_CMD="sudo nixos-rebuild switch --flake .#"
      else
        REBUILD_CMD="nixos-rebuild switch --flake .#$FLAKE_HOST --target-host $SSH_TARGET --use-remote-sudo --ask-sudo-password"
      fi

      if $REBUILD_CMD; then
        echo "NixOS deploy successful, committing changes to git..."
        commit_and_push
        notify_success
      else
        echo "NixOS deploy failed, not committing changes."
        notify_failure
        popd > /dev/null
        exit 1
      fi
      popd > /dev/null
    '';
  };
in {
  users.users.${user.login}.packages = [deploy];
}
