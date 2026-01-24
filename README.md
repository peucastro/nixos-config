# NixOS & Home Manager Configurations

[![built-with-nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![nixos-nixos-25.11](https://img.shields.io/badge/NixOS-25.11-informational.svg?logo=nixos)](https://github.com/NixOS/nixpkgs/tree/nixos-25.11)
[![lint](https://github.com/peucastro/nixos-config/actions/workflows/lint.yaml/badge.svg)](https://github.com/peucastro/nixos-config/actions/workflows/lint.yaml)
[![flake-eval](https://github.com/peucastro/nixos-config/actions/workflows/flake-eval.yaml/badge.svg)](https://github.com/peucastro/nixos-config/actions/workflows/flake-eval.yaml)
[![license](https://img.shields.io/github/license/peucastro/nixos-config)](https://github.com/peucastro/nixos-config/blob/main/LICENSE)

My NixOS setup running on a couple of laptops and a home server. Everything is managed through flakes with a modular structure that makes it easy to share configuration between machines while keeping host-specific stuff separate.

> [!WARNING]
> This is a _single user_ setup and is not intended to be anything else.

## Structure

```sh
├── flake.nix       # Main flake configuration
├── hosts/          # Per-host configurations
│   ├── ideapad/
│   └── yoga/
├── modules/        # Modular configurations
│   ├── core/       # NixOS modules
│   └── home/       # Home Manager modules
├── profiles/       # Reusable system profiles
└── secrets/        # Encrypted secrets management
```

## Software

### Core System

- **Window Manager:** [`Hyprland`](https://hypr.land/)
- **Status Bar:** [`Waybar`](https://github.com/Alexays/Waybar/)
- **Wallpaper Manager:** [`awww`](https://codeberg.org/LGFae/awww/) + [`waypaper`](https://anufrievroman.gitbook.io/waypaper/)
- **Idle Daemon:** [`hypridle`](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/)
- **Screen Locker:** [`hyprlock`](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/)
- **Logout Menu:** [`wlogout`](https://github.com/ArtsyMacaw/wlogout/)
- **Notification Daemon:** [`dunst`](https://dunst-project.org/)
- **Display Manager**: [`greetd`](https://sr.ht/~kennylevinsen/greetd/) + [`tuigreet`](https://github.com/apognu/tuigreet/)
- **Monitors Manager**: [`kanshi`](https://gitlab.freedesktop.org/emersion/kanshi/)
- **Clipboard Manager:** [`wl-clipboard`](https://github.com/bugaevc/wl-clipboard/) + [`cliphist`](https://github.com/sentriz/cliphist/)

### Terminal & Shell

- **Terminal Emulator:** [`Alacritty`](https://alacritty.org/index.html/)
- **Shell:** [`Zsh`](https://www.zsh.org/)
  - **Plugin Manager:** [`oh-my-zsh`](https://ohmyz.sh/)
  - **Plugins:** [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions/), [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting/)
- **Text Editors:** [`Neovim`](https://neovim.io/)
- **Terminal Multiplexer:** [`tmux`](https://github.com/tmux/tmux/)
- **System Information:** [`fastfetch`](https://github.com/fastfetch-cli/fastfetch/)

### Applications

- **Application Launcher:** [`Rofi`](https://davatorium.github.io/rofi/)
- **Code Editor:** [`VS Code`](https://code.visualstudio.com/), [`Zed`](https://zed.dev/)
- **Web Browser:** [`Zen`](https://zen-browser.app/), [`Chromium`](https://www.chromium.org/chromium-projects/)

## Home Server

A headless server running various self-hosted services like Jellyfin for media streaming, Immich for photos, and the *arr stack for managing downloads. Everything is connected through Tailscale for remote access, with AdGuard Home handling DNS filtering. Services are configured declaratively through NixOS with Caddy reverse proxy handling SSL certificates via Cloudflare DNS.

> This section is generated automatically from the Nix configuration using [this cursed Nix script](https://github.com/peucastro/nixos-config/blob/main/scripts/generate-services-table.nix).

### Downloads

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/deluge.svg' width=32 height=32>|Deluge|BitTorrent client with web UI|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/qbittorrent.svg' width=32 height=32>|qBittorrent|Bittorrent client with web UI|

### Media

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg' width=32 height=32>|Immich|Self-hosted photo management|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg' width=32 height=32>|Jellyfin|Media streaming server|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyseerr.svg' width=32 height=32>|Jellyseerr|Media request and management for Jellyfin.|

### Monitoring

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/glances.svg' width=32 height=32>|Glances|System monitoring web UI|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/uptime-kuma.svg' width=32 height=32>|Uptime Kuma|Self-hosted monitoring service|

### Network

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/adguard-home.svg' width=32 height=32>|AdGuard Home|DNS server with ad/tracker blocking and web UI|

### Servarr

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/bazarr.svg' width=32 height=32>|Bazarr|Subtitle management for Radarr/Sonarr|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/prowlarr.svg' width=32 height=32>|Prowlarr|Indexer manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/radarr.svg' width=32 height=32>|Radarr|Movie collection manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/sonarr.svg' width=32 height=32>|Sonarr|TV show collection manager for Usenet and BitTorrent|

### Utilities

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/filebrowser.svg' width=32 height=32>|Filebrowser|Web file manager|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/homepage.png' width=32 height=32>|Homepage|Application dashboard.|

## License

This project is licensed under the terms of the MIT license. Check [LICENSE](LICENSE) for details.
