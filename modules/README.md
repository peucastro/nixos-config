# Modules

This directory contains modular NixOS and Home Manager configuration files, organized for easy maintainability and reusability.

## Structure

### Core (`core/`)

NixOS system-level configuration modules:

- `base/` - Essential system settings such as user management, security, networking, and package manager configuration
- `desktop/` - Desktop environment and display manager configuration
- `gaming/` - Gaming configuration, such as Steam, GameMode, Proton, etc.
- `hardware/` - Hardware-specific configuration, including audio, Bluetooth, and keyboard layout
- `server/` - Home server configuration and services
- `services/` - System services like login managers, printing, power profiles, and backup solutions
- `system/` - High-level system configuration, including bootloader setup, environment variables, locale, and MIME types
- `virtualisation/` - Virtualization tools like Docker and Podman

### Home (`home/`)

Home Manager user environment configuration modules:

- `base/` - Shells, git, and essential CLI tools
- `cli/` - Commmand-line interface applications and utilities.
- `gui/` - Graphical applications, desktop environments, and GUI packages
- `tui/` - Terminal user interface programs, editors, and utilities

## Usage

Each top-level module (`core/`, `home/`) and their submodules contain a `default.nix` file that imports all modules in that directory. This allows you to easily include entire sets of related configurations by importing the appropriate `default.nix` file.
