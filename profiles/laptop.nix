{
  pkgs,
  user,
  ...
}: {
  imports = [../modules/core];

  networking.networkmanager = {
    plugins = [
      pkgs.networkmanager-l2tp
      pkgs.networkmanager-openconnect
      pkgs.networkmanager-openvpn
      pkgs.networkmanager-strongswan
    ];
    wifi.powersave = true;
  };

  networking.firewall.allowedTCPPorts = [22 80 443];

  users.extraGroups.networkmanager.members = [user.login];

  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    powertop
    acpi
  ];
}
