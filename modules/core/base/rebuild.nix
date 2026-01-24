{
  pkgs,
  user,
  ...
}: let
  name = "system-rebuild";
  version = "1.0.0";
  pname = "peucastro-nixos-config-${name}";

  system-rebuild = pkgs.writeShellApplication {
    inherit name;
    meta = {
      description = "Rebuild NixOS system with Git synchronization";
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
        while true; do
          case "$1" in
            -h|--help)
              echo "Usage: ${name} [OPTIONS]"
              echo
              echo "Rebuild NixOS system with Git synchronization."
              echo
              echo "Options:"
              echo "  -h, --help   Show this help message and exit."
              echo "  -f, --force  Force rebuild, even if there are no changes to commit."
              echo
              exit 0
              ;;
            -f|--force)
              shift
              REBUILD_FORCE=true
              ;;
            --)
              shift
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
        notify-send -e "NixOS rebuild failed!" --icon=dialog-error
      }

      parse_options "$@"
      pushd ~/nixos-config > /dev/null
      format_files
      if ! should_rebuild; then
        popd > /dev/null
        exit 0
      fi
      echo "Rebuilding NixOS system..."
      if sudo nixos-rebuild switch --flake .#; then
        echo "NixOS rebuild successful, committing changes to git..."
        commit_and_push
        notify_success
      else
        echo "NixOS rebuild failed, not committing changes."
        notify_failure
        popd > /dev/null
        exit 1
      fi
      popd > /dev/null
    '';
  };
in {
  users.users.${user.login}.packages = [system-rebuild];
}
