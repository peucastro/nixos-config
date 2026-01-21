{user, ...}: let
  inherit (import ./colors.nix) colors;
  userName = user.displayName;
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        color = "rgb(${colors.background-alt})";
      };

      input-field = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 2;
        rounding = 10;
        position = "0, -100";
        halign = "center";
        valign = "center";
        placeholder_text = "<i>Input password...</i>";
        fail_text = "$PAMFAIL";
        dots_spacing = 0.3;
        fade_on_empty = false;
        font_family = "Adwaita";
        outer_color = "rgba(${colors.border}ff) rgba(${colors.focused}ff) 45deg";
        inner_color = "rgb(${colors.background-dim})";
        font_color = "rgb(${colors.foreground})";
        fail_color = "rgba(${colors.red}ff) rgba(${colors.orange}ff) 45deg";
        check_color = "rgba(${colors.green}ff) rgba(${colors.blue}ff) 45deg";
        shadow_passes = 10;
        shadow_size = 20;
        shadow_color = "rgb(${colors.gray})";
        shadow_boost = 1.5;
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 90;
          font_family = "Adwaita";
          position = "0, -250";
          halign = "center";
          valign = "top";
          color = "rgb(${colors.foreground})";
        }
        {
          monitor = "";
          text = "cmd[update:60000] date +\"%A, %d %B %Y\"";
          font_size = 25;
          font_family = "Adwaita";
          position = "0, -400";
          halign = "center";
          valign = "top";
          color = "rgb(${colors.foreground-alt})";
        }
        {
          monitor = "";
          text = "${userName}";
          font_size = 20;
          font_family = "Adwaita";
          color = "rgb(${colors.foreground-alt})";
          position = "-100, 160";
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = 10;
        }
        {
          monitor = "";
          text = "$LAYOUT[pt, en]";
          font_size = 24;
          font_family = "Adwaita";
          onclick = "hyprctl switchxkblayout all next";
          position = "250, -100";
          halign = "center";
          valign = "center";
          color = "rgb(${colors.foreground-alt})";
        }
      ];
    };
  };
}
