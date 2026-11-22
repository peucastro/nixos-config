{pkgs, ...}: {
  services = {
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
  };

  programs.seahorse.enable = true;
  environment.systemPackages = [pkgs.libsecret];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend";
  };
}
