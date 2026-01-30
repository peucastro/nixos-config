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

## Installation

1. Boot the NixOS installer ISO
2. Set up network connection (WiFi or ethernet)
3. Mount VeraCrypt USB and copy SSH keys to `/etc/ssh/`
4. Clone this repo: `git clone https://github.com/peucastro/nixos-config`
5. Update disk device in `hosts/<hostname>/disk-configuration.nix`
6. Run disko: `sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/<hostname>/disk-configuration.nix`
7. Install: `sudo nixos-install --flake .#<hostname>`
8. Reboot

## Software

### Core System

- **Window Manager:** [`Hyprland`](https://hypr.land/)
- **Status Bar:** [`Waybar`](https://github.com/Alexays/Waybar/)
- **Wallpaper Manager:** [`awww`](https://codeberg.org/LGFae/awww/) + [`waypaper`](https://anufrievroman.gitbook.io/waypaper/)
- **Idle Daemon:** [`hypridle`](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/)
- **Screen Locker:** [`hyprlock`](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/)
- **Logout Menu:** [`wlogout`](https://github.com/ArtsyMacaw/wlogout/)
- **Notification Daemon:** [`dunst`](https://dunst-project.org/)
- **Display Manager:** [`greetd`](https://sr.ht/~kennylevinsen/greetd/) + [`tuigreet`](https://github.com/apognu/tuigreet/)
- **Monitor Manager:** [`kanshi`](https://gitlab.freedesktop.org/emersion/kanshi/)
- **Clipboard Manager:** [`wl-clipboard`](https://github.com/bugaevc/wl-clipboard/) + [`cliphist`](https://github.com/sentriz/cliphist/)
- **Screenshot Tool:** [`grim`](https://sr.ht/~emersion/grim/) + [`slurp`](https://github.com/emersion/slurp) + [`swappy`](https://github.com/jtheoof/swappy/)
- **Night Light:** [`wlsunset`](https://sr.ht/~kennylevinsen/wlsunset/)

### Terminal & Shell

- **Terminal Emulator:** [`Alacritty`](https://alacritty.org/), [`Ghostty`](https://ghostty.org/)
- **Shell:** [`Zsh`](https://www.zsh.org/)
  - **Plugin Manager:** [`oh-my-zsh`](https://ohmyz.sh/)
  - **Plugins:** [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions/), [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting/)
- **Text Editor:** [`Neovim`](https://neovim.io/)
- **Terminal Multiplexer:** [`tmux`](https://github.com/tmux/tmux/)
- **System Monitor:** [`btop`](https://github.com/aristocratos/btop/), [`fastfetch`](https://github.com/fastfetch-cli/fastfetch/)
- **CLI Tools:** [`bat`](https://github.com/sharkdp/bat/), [`eza`](https://github.com/eza-community/eza/), [`fd`](https://github.com/sharkdp/fd/), [`ripgrep`](https://github.com/BurntSushi/ripgrep/), [`fzf`](https://github.com/junegunn/fzf/)

### Applications

- **Application Launcher:** [`Rofi`](https://davatorium.github.io/rofi/)
- **Code Editors:** [`VS Code`](https://code.visualstudio.com/), [`Zed`](https://zed.dev/)
- **Web Browsers:** [`Zen`](https://zen-browser.app/), [`Firefox`](https://www.mozilla.org/firefox/), [`ungoogled-chromium`](https://github.com/ungoogled-software/ungoogled-chromium/)
- **Communication:** [`Discord`](https://discord.com/), [`Slack`](https://slack.com/), [`Telegram`](https://telegram.org/)
- **Office & Productivity:** [`LibreOffice`](https://www.libreoffice.org/), [`Obsidian`](https://obsidian.md/), [`Calibre`](https://calibre-ebook.com/)
- **Utilities:** [`Bitwarden`](https://bitwarden.com/), [`qBittorrent`](https://www.qbittorrent.org/), [`LocalSend`](https://localsend.org/)

## Home Server

A headless server running various self-hosted services like Jellyfin for media streaming, Immich for photos, and the *arr stack for managing downloads. Everything is connected through Tailscale for remote access, with AdGuard Home handling DNS filtering. Services are configured declaratively through NixOS with Caddy reverse proxy handling SSL certificates via Cloudflare DNS.

> This section is generated automatically from the Nix configuration using [this cursed Nix script](https://github.com/peucastro/nixos-config/blob/main/scripts/generate-services-table.nix).

### Downloads

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/deluge.svg' width=32 height=32>|Deluge|BitTorrent client with web UI|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/qbittorrent.svg' width=32 height=32>|qBittorrent|Bittorrent client with web UI|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/soulseek.png' width=32 height=32>|Soulseek|Peer-to-peer music sharing|

### Media

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/calibre-web.svg' width=32 height=32>|Calibre-Web|Ebook library manager and reader|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg' width=32 height=32>|Immich|Self-hosted photo management|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg' width=32 height=32>|Jellyfin|Media streaming server|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyseerr.svg' width=32 height=32>|Jellyseerr|Media request and management for Jellyfin.|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/navidrome.svg' width=32 height=32>|Navidrome|Modern music server and streamer|

### Monitoring

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/glances.svg' width=32 height=32>|Glances|System monitoring web UI|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/grafana.svg' width=32 height=32>|Grafana|Analytics and monitoring dashboards|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/prometheus.svg' width=32 height=32>|Prometheus|Metrics collection and alerting|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/uptime-kuma.svg' width=32 height=32>|Uptime Kuma|Self-hosted monitoring service|

### Network

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/adguard-home.svg' width=32 height=32>|AdGuard Home|DNS server with ad/tracker blocking and web UI|

### Servarr

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/bazarr.svg' width=32 height=32>|Bazarr|Subtitle management for Radarr/Sonarr|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/lidarr.svg' width=32 height=32>|Lidarr|Music collection manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/prowlarr.svg' width=32 height=32>|Prowlarr|Indexer manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/radarr.svg' width=32 height=32>|Radarr|Movie collection manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/readarr.svg' width=32 height=32>|Readarr|Ebook and audiobook collection manager for Usenet and BitTorrent|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/sonarr.svg' width=32 height=32>|Sonarr|TV show collection manager for Usenet and BitTorrent|

### Utilities

|Icon|Name|Description|
|---|---|---|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/filebrowser.svg' width=32 height=32>|Filebrowser|Web file manager|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/homepage.png' width=32 height=32>|Homepage|Application dashboard.|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/linkwarden.png' width=32 height=32>|Linkwarden|Bookmark manager and archive|
|<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/stirling-pdf.svg' width=32 height=32>|Stirling PDF|PDF manipulation and conversion tool|

## License

This project is licensed under the terms of the MIT license. Check [LICENSE](LICENSE) for details.
