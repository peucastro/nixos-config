# Profiles

This directory contains reusable system profiles that encapsulate common configurations for different machine types.

## Types

- `laptop.nix` - Configuration for laptops with desktop environment, gaming support, power management, and NetworkManager.
- `server.nix` - Configuration for headless servers with minimal packages, firewall, and server-specific modules.
- `workstation.nix` - Configuration for desktop workstations with desktop environment, gaming support, and additional system tools.

## Usage

Each host imports the appropriate profile in its `default.nix`:

```nix
imports = [
  ../../profiles/server.nix
];
```
