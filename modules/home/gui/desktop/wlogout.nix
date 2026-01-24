{config, ...}: let
  inherit (import ./colors.nix) colors;
  homeDir = config.home.homeDirectory;
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = "loginctl lock-session";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "hibernate";
        "action" = "systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
      {
        "label" = "logout";
        "action" = "loginctl terminate-user $USER";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }
      {
        "label" = "suspend";
        "action" = "systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
    style = ''
      * {
        font-family: Inter, sans-serif;
        font-size: 16px;
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: #${colors.background-alt};
      }

      button {
        border-radius: 6px;
        border-color: #${colors.border};
        text-decoration-color: #${colors.foreground};
        color: #${colors.foreground};
        background-color: #${colors.background-alt};
        border-style: solid;
        border-width: 2px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 8px;
        padding: 16px 32px;
        transition: background 0.2s, color 0.2s;
      }

      button:focus, button:active, button:hover {
        color: #${colors.background};
        background-color: #${colors.background-dim};
        border-color: #${colors.focused};
        outline-style: none;
      }

      #lock {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/lock.png"));
      }

      #lock:hover,
      #lock:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/lock_hover.png"));
      }

      #logout {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/logout.png"));
      }

      #logout:hover,
      #logout:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/logout_hover.png"));
      }

      #suspend {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/suspend.png"));
      }

      #suspend:hover,
      #suspend:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/suspend_hover.png"));
      }

      #hibernate {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/hibernate.png"));
      }

      #hibernate:hover,
      #hibernate:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/hibernate_hover.png"));
      }

      #shutdown {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/shutdown.png"));
      }

      #shutdown:hover,
      #shutdown:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/shutdown_hover.png"));
      }

      #reboot {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/reboot.png"));
      }

      #reboot:hover,
      #reboot:focus {
        background-image: image(url("${homeDir}/nixos-config/assets/icons/power/reboot_hover.png"));
      }
    '';
  };
}
