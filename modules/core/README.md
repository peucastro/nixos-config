# Core Modules

This directory contains the main NixOS configuration modules for your system, organized for clarity and modularity:

- `base/` - Handles essential system settings such as user management, security, networking, and package manager configuration.
- `desktop/` - Desktop environment and display manager configuration.
- `gaming/` - Manages gaming configuration, such as steam, `gamemode`, proton, etc.
- `hardware/` - Manages hardware-specific configuration, including audio, Bluetooth, and keyboard layout.
- `services/` - Configures system services like login managers, printing, power profiles, and backup solutions.
- `system/` - Covers high-level system configuration, including bootloader setup, environment variables, locale, and MIME types.
- `virtualisation/` - Contains the configurations for virtualisation tools, such as VirtualBox and Docker.

Each subfolder contains a `default.nix` that imports all modules in that folder.
