# NixOS & Home Manager Configurations

[![built-with-nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![nixos-nixos-25.11](https://img.shields.io/badge/NixOS-25.11-informational.svg?logo=nixos)](https://github.com/NixOS/nixpkgs/tree/nixos-25.11)
[![lint](https://github.com/peucastro/nixos-config/actions/workflows/lint.yaml/badge.svg)](https://github.com/peucastro/nixos-config/actions/workflows/lint.yaml)
[![flake-eval](https://github.com/peucastro/nixos-config/actions/workflows/flake-eval.yaml/badge.svg)](https://github.com/peucastro/nixos-config/actions/workflows/flake-eval.yaml)
[![license](https://img.shields.io/github/license/peucastro/nixos-config)](https://github.com/peucastro/nixos-config/blob/main/LICENSE)

> [!WARNING]
> This is a _single user_ setup and is not intended to be anything else.

## 📦 Software

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
