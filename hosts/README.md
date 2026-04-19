# Hosts

This directory contains all host-specific configurations for my NixOS systems. Each host folder includes hardware, disk, state, and user environment configuration.

## Physical Machines

| Host      | Platform | Hardware                 | Purpose                     | Status      |
| --------- | -------- | ------------------------ | --------------------------- | ----------- |
| `yoga`    | NixOS    | Lenovo Yoga Pro 7 14ASP9 | College, Work and Daily Use | ✅ Active   |
| `kim`     | NixOS    | Generic Server           | Home server                 | ✅ Active   |
| `khloe`   | NixOS    | Virtual Machine          | Deployment Testing          | ✅ Active   |
| `ideapad` | NixOS    | Lenovo Ideapad 5 14ALC05 | College and Daily Use       | ⚪ Not Used |

## How to Add a New Host

1. Create a new folder under `hosts/` named after your machine (e.g., `hosts/laptop`).
2. Add the following files:

- `hardware-configuration.nix`: Hardware scan from `nixos-generate-config --no-filesystems`.
- `disk-configuration.nix`: Disk layout and mountpoints (using [`disko`](https://github.com/nix-community/disko)).
- `state-configuration.nix`: System and home state version.
- `home-configuration.nix`: Home Manager and user environment imports.
- `default.nix`: Imports all configuration files and core modules.

## Usage

To build or switch to a host configuration, use:

```sh
nixos-rebuild switch --flake .#<hostname>
```

or only for home-manager:

```sh
home-manager switch --flake .#<hostname>
```
