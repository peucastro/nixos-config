# Profiles

This directory contains reusable system profiles that encapsulate common configurations for different machine types.

## Types

- `laptop.nix` - Configuration for laptops with desktop environment, gaming support, power management, NetworkManager, and laptop secrets.
- `server.nix` - Configuration for headless servers with minimal packages, firewall, server-specific modules, and server secrets.

## Usage

Each host imports the appropriate profile in its `default.nix`:

```nix
imports = [
  ../../profiles/server.nix
];
```
