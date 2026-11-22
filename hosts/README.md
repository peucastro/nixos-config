# Hosts

This directory contains all host-specific configurations for my NixOS systems. Each host folder includes the hardware, disk, state, and user environment configuration that is specific to that machine.

## Machines

| Host      | Platform | Hardware                 | Purpose                     | Status      |
| --------- | -------- | ------------------------ | --------------------------- | ----------- |
| `kim`     | NixOS    | Intel N150 Mini PC       | Home server                 | ✅ Active   |
| `khloe`   | NixOS    | VirtualBox VM            | NixOS change testing        | ✅ Active   |
| `yoga`    | NixOS    | Lenovo Yoga Pro 7 14ASP9 | College, Work and Daily Use | ⚪ Not Used |
| `ideapad` | NixOS    | Lenovo Ideapad 5 14ALC05 | College and Daily Use       | ⚪ Not Used |

Every host is registered in the `hosts` attribute in `flake.nix`, which feeds `nixosConfigurations` and the deploy nodes.

## How to Add a New Host

1. Create `hosts/<name>/` with at least `default.nix` and `hardware-configuration.nix`.
2. Add the optional files you need:
   - `disk-configuration.nix`: disko layout (bare metal).
   - `state-configuration.nix`: system and home state versions.
   - `home-configuration.nix`: Home Manager imports (desktop hosts).
3. Import the matching profile from `profiles/` (`laptop.nix` or `server.nix`).
4. Register the host in the `hosts` attribute in `flake.nix`.

## Usage

To build or switch to a host configuration:

```sh
nixos-rebuild switch --flake .#<hostname>
```

Home Manager is embedded in the NixOS configuration (`useGlobalPkgs = true`), so there is no separate `home-manager switch` target.
