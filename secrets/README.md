# Secrets

This is my personal [agenix](https://github.com/ryantm/agenix/) configuration for managing encrypted secrets using the [age](https://github.com/FiloSottile/age/) encryption tool within NixOS.

## How it works

- Secrets are stored in an external private repository and included in my flake inputs.
- The module imports agenix and references secret files from `${secrets}`.
- Public keys for age encryption are managed in `secrets.nix` (see example below).

### Example: `secrets.nix`

```nix
let
  sharedKey = ''
    ssh-ed25519 ... peucastro@agenix
  '';

  recoveryKey = ''
    ssh-ed25519 ... peucastro@agenix-recovery
  '';

  id_ed25519 = ''
    ssh-ed25519 ... falecompedroac@gmail.com
  '';

  trustedKeys = [sharedKey recoveryKey];
in {
  "id_ed25519.age".publicKeys = trustedKeys ++ [id_ed25519];
}
```

### Example: `default.nix`

```nix
{
  age = {
    identityPaths = [
      "/etc/ssh/agenix_shared_key"
      "/etc/ssh/agenix_recovery_key"
    ];
    secrets = {
      id_ed25519 = {
        file = "${secrets}/id_ed25519.age";
        path = "/home/peu/.ssh/id_ed25519";
        symlink = true;
        mode = "0400";
        owner = "peu";
        group = "users";
      };
    };
  };
}
```

## Bootstrapping

This setup has a circular dependency: an SSH key is needed to fetch the secrets from a private repository, but the configuration itself manages those SSH keys as encrypted secrets.

To break this cycle, the initial deployment uses a [VeraCrypt](https://veracrypt.io/en/)-encrypted USB drive containing all the SSH keys. This external device delivers the necessary keys before the system configuration is applied.

Once bootstrapped this way, all future access to secrets and configuration is automated and secured by the system itself.
