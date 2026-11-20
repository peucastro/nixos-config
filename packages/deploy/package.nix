{
  lib,
  writeShellApplication,
  coreutils,
  git,
  libnotify,
  jq,
  util-linux,
  openssh,
  deploy-rs,
}:
writeShellApplication {
  name = "deploy";
  meta = {
    description = "Deploy NixOS systems with Git synchronization";
    license = lib.licenses.mit;
  };

  runtimeInputs = [
    coreutils
    git
    libnotify
    jq
    util-linux
    openssh
    deploy-rs
  ];

  text = ''
    name="deploy"
    HOST="$(uname -n)"

    parse_options() {
      opts="$(getopt -n "$name" -o hf -l help,force -- "$@")"
      eval set -- "$opts"
      REBUILD_FORCE=false
      FLAKE_HOST=""
      while true; do
        case "$1" in
          -h|--help)
            echo "Usage: $name [OPTIONS] [FLAKE_HOST]"
            echo
            echo "Deploying NixOS system with Git synchronization."
            echo
            echo "Options:"
            echo "  -h, --help     Show this help message and exit."
            echo "  -f, --force    Force deploy, even if there are no changes to commit."
            echo
            echo "Arguments:"
            echo "  FLAKE_HOST     Flake hostname (e.g., kim). Omit to deploy the local system."
            echo
            echo "Examples:"
            echo "  $name                                          # Local deploy (NixOS only)"
            echo "  $name kim                                      # Remote deploy to kim via deploy-rs"
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
      nix fmt . &>/dev/null || nix fmt .
      git add .
    }

    should_rebuild() {
      local host="$1"
      last_built_commit=$(git rev-parse --verify --quiet "''${host}^{}" || echo "<not-found>")
      current_commit=$(git rev-parse HEAD)
      if [ "$REBUILD_FORCE" = "true" ]; then
        return 0
      fi
      if [ "$last_built_commit" = "$current_commit" ] && git diff --staged --quiet; then
        echo "No new changes detected, exiting."
        echo
        return 1
      fi
      return 0
    }

    get_ssh_target() {
      local node="$1"
      local hostname ssh_user
      hostname=$(nix eval --raw ".#deploy.nodes.''${node}.hostname" 2>/dev/null)
      ssh_user=$(nix eval --raw ".#deploy.nodes.''${node}.sshUser" 2>/dev/null)
      echo "$ssh_user@$hostname"
    }

    get_generation_json() {
      local host="$1"
      local ssh_target
      if [ -z "$host" ]; then
        nixos-rebuild list-generations --json
      else
        ssh_target=$(get_ssh_target "$host")
        ssh "$ssh_target" "nixos-rebuild list-generations --json"
      fi
    }

    get_generation_number() {
      local host="$1"
      local generation
      generation=$(get_generation_json "$host" | jq -r '.[] | select(.current == true) | .generation')
      [ -n "$generation" ] || return 1
      echo "$generation"
    }

    get_generation_info() {
      local host="$1"
      local tag="$2"
      get_generation_json "$host" | jq -r --arg host "$tag" \
        '.[] | select(.current == true) | "rebuild(\($host)): generation \(.generation), NixOS \(.nixosVersion) with Linux Kernel \(.kernelVersion)"'
    }

    commit_and_push() {
      local host="$1"
      local message="$2"
      local branch
      git commit --allow-empty -m "$message"
      git tag -f "$host" HEAD
      branch=$(git branch --show-current)
      if [ -z "$branch" ]; then
        echo "Error: not on a branch (detached HEAD); cannot push." >&2
        exit 1
      fi
      if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
        git push
      else
        git push --set-upstream origin "$branch"
      fi
      git push --tags --force
    }

    notify_success() {
      if command -v notify-send &>/dev/null; then
        notify-send -t 5000 -e "NixOS successfully deployed!" --icon=software-update-available
      fi
    }

    notify_failure() {
      if command -v notify-send &>/dev/null; then
        notify-send -t 5000 -e "NixOS deploy failed!" --icon=dialog-error
      fi
    }

    parse_options "$@"

    if [ -z "$FLAKE_HOST" ] && ! command -v nixos-rebuild &>/dev/null; then
      echo "Error: local deploys require NixOS (nixos-rebuild not found)." >&2
      echo "Pass a flake host instead, e.g. '$name kim'." >&2
      exit 1
    fi

    target_host="''${FLAKE_HOST:-$HOST}"

    pushd ~/nixos-config >/dev/null

    STASHED=false
    restore_stash() {
      if [ "$STASHED" = true ]; then
        git stash pop || echo "Error: failed to restore stashed changes; resolve them manually." >&2
      fi
    }
    trap restore_stash EXIT

    if ! git diff --quiet || ! git diff --cached --quiet; then
      git stash push -m "deploy autostash"
      STASHED=true
    fi

    if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
      git pull --rebase
    else
      echo "No upstream for $(git branch --show-current); skipping pull."
    fi

    if [ "$STASHED" = true ]; then
      # Clear the flag before popping so a failed pop is not retried by the trap.
      STASHED=false
      if ! git stash pop; then
        echo "Error: failed to restore stashed changes; run 'git stash list' and 'git stash pop'." >&2
        exit 1
      fi
    fi

    format_files
    if ! should_rebuild "$target_host"; then
      popd >/dev/null
      exit 0
    fi

    previous_generation=$(get_generation_number "$FLAKE_HOST") || previous_generation=""

    deploy_ok=false
    if [ -z "$FLAKE_HOST" ]; then
      echo "Deploying local NixOS system..."
      if sudo nixos-rebuild switch --flake .#; then
        deploy_ok=true
      fi
    else
      echo "Deploying NixOS system '$FLAKE_HOST' via deploy-rs..."
      if deploy --interactive-sudo false ".#$FLAKE_HOST"; then
        deploy_ok=true
      fi
    fi

    if [ "$deploy_ok" = true ]; then
      new_generation=$(get_generation_number "$FLAKE_HOST") || new_generation=""

      if [ -z "$new_generation" ]; then
        message="deploy($target_host): generation unknown"
      elif [ "$new_generation" = "$previous_generation" ]; then
        message="deploy($target_host): no new generation (still $new_generation)"
      else
        message=$(get_generation_info "$FLAKE_HOST" "$target_host")
      fi

      echo "NixOS deploy successful, committing changes to git..."
      commit_and_push "$target_host" "$message"
      notify_success
    else
      echo "NixOS deploy failed, not committing changes."
      notify_failure
      popd >/dev/null
      exit 1
    fi

    popd >/dev/null
  '';
}
