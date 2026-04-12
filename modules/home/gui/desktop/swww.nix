{pkgs, ...}: {
  services.awww.enable = true;
  home.packages = [pkgs.waypaper];

  systemd.user.services.waypaper = {
    Unit = {
      Description = "Set a random wallpaper with Waypaper";
      After = "graphical-session.target";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.timers.waypaper = {
    Unit = {
      Description = "Set a random wallpaper every 30 minutes";
    };
    Timer = {
      Persistent = true;
      OnCalendar = "*:0/30";
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
