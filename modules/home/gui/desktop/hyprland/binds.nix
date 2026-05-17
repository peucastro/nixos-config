{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$modifier, Return, exec, $terminal"
      "$modifier, E, exec, $fileManager"
      "$modifier, D, exec, $menu"
      "$modifier, C, exec, cliphist list | $menu -dmenu | cliphist decode | wl-copy && wtype -M ctrl v -m ctrl"
      "$modifier SHIFT, E, exec, rofi -show emoji | wl-copy && wtype -M ctrl v -m ctrl"
      "$modifier, B, exec, $browser"
      "$modifier, P, exec, grim -o $(hyprctl monitors -j | jq -r 'map(select(.focused)) | .[] | .name') - | swappy -f -"
      "$modifier SHIFT, P, exec, grim -g \"$(slurp)\" - | swappy -f -"
      "$modifier SHIFT, C, exec, hyprpicker --autocopy --format=hex"
      "$modifier, W, exec, waypaper --random"

      "$modifier, Q, killactive,"
      "$modifier, V, togglefloating,"
      "$modifier, U, pseudo,"
      "$modifier, I, layoutmsg, togglesplit"

      "$modifier, X, exec, loginctl lock-session"
      "$modifier SHIFT, X, exit,"
      "$modifier SHIFT, S, exec, systemctl suspend || loginctl suspend"
      "CONTROLALT, DELETE, exec, wlogout"

      "$modifier, left, movefocus, l"
      "$modifier, right, movefocus, r"
      "$modifier, up, movefocus, u"
      "$modifier, down, movefocus, d"
      "$modifier, h, movefocus, l"
      "$modifier, l, movefocus, r"
      "$modifier, k, movefocus, u"
      "$modifier, j, movefocus, d"

      "$modifier SHIFT, left, movewindow, l"
      "$modifier SHIFT, right, movewindow, r"
      "$modifier SHIFT, up, movewindow, u"
      "$modifier SHIFT, down, movewindow, d"
      "$modifier SHIFT, h, movewindow, l"
      "$modifier SHIFT, l, movewindow, r"
      "$modifier SHIFT, k, movewindow, u"
      "$modifier SHIFT, j, movewindow, d"

      "$modifier, 1, workspace, 1"
      "$modifier, 2, workspace, 2"
      "$modifier, 3, workspace, 3"
      "$modifier, 4, workspace, 4"
      "$modifier, 5, workspace, 5"
      "$modifier, 6, workspace, 6"
      "$modifier, 7, workspace, 7"
      "$modifier, 8, workspace, 8"
      "$modifier, 9, workspace, 9"
      "$modifier, 0, workspace, 10"

      "$modifier SHIFT, 1, movetoworkspace, 1"
      "$modifier SHIFT, 2, movetoworkspace, 2"
      "$modifier SHIFT, 3, movetoworkspace, 3"
      "$modifier SHIFT, 4, movetoworkspace, 4"
      "$modifier SHIFT, 5, movetoworkspace, 5"
      "$modifier SHIFT, 6, movetoworkspace, 6"
      "$modifier SHIFT, 7, movetoworkspace, 7"
      "$modifier SHIFT, 8, movetoworkspace, 8"
      "$modifier SHIFT, 9, movetoworkspace, 9"
      "$modifier SHIFT, 0, movetoworkspace, 10"

      "$modifier, SPACE, togglespecialworkspace"
      "$modifier SHIFT, SPACE, movetoworkspace, special"

      "$modifier, F,fullscreen, 1"
      "$modifier SHIFT, F,fullscreen, 0"

      "$modifier CONTROL, right, workspace, e+1"
      "$modifier CONTROL, left, workspace, e-1"

      "$modifier ALT, left, resizeactive,-30 0"
      "$modifier ALT, right, resizeactive,30 0"
      "$modifier ALT, up, resizeactive,0 -30"
      "$modifier ALT, down, resizeactive,0 30"
      "$modifier ALT, h, resizeactive,-30 0"
      "$modifier ALT, l, resizeactive,30 0"
      "$modifier ALT, k, resizeactive,0 -30"
      "$modifier ALT, j, resizeactive,0 30"
    ];

    bindm = [
      "$modifier, mouse:272, movewindow"
      "$modifier, mouse:273, resizewindow"
    ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') && dunstify -a volume -h string:x-canonical-private-synchronous:volume -h int:value:$vol \"Volume: $vol%\""
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') && dunstify -a volume -h string:x-canonical-private-synchronous:volume -h int:value:$vol \"Volume: $vol%\""
      ",XF86MonBrightnessUp, exec, brightnessctl set 10%+ && brightness=$(awk \"BEGIN {printf \\\"%d\\\", $(brightnessctl get) * 100 / $(brightnessctl max)}\") && dunstify -a brightness -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness \"Brightness: $brightness%\""
      ",XF86MonBrightnessDown, exec, brightnessctl set 10%- && brightness=$(awk \"BEGIN {printf \\\"%d\\\", $(brightnessctl get) * 100 / $(brightnessctl max)}\") && dunstify -a brightness -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness \"Brightness: $brightness%\""
    ];

    bindl = [
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@) && if echo $status | grep -q MUTED; then dunstify -a volume -h string:x-canonical-private-synchronous:volume \"Volume: Muted\"; else vol=$(echo $status | awk '{print int($2*100)}') && dunstify -a volume -h string:x-canonical-private-synchronous:volume -h int:value:$vol \"Volume: $vol%\"; fi"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then dunstify -a volume -h string:x-canonical-private-synchronous:mic \"Microphone: Muted\"; else dunstify -a volume -h string:x-canonical-private-synchronous:mic \"Microphone: Unmuted\"; fi"
      ",XF86AudioNext, exec, playerctl next"
      ",XF86AudioPause, exec, playerctl play-pause"
      ",XF86AudioPlay, exec, playerctl play-pause"
      ",XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
