{
  pkgs,
  user,
  ...
}: {
  imports = [../modules/core];

  networking.networkmanager.plugins = [
    pkgs.networkmanager-l2tp
    pkgs.networkmanager-openconnect
    pkgs.networkmanager-openvpn
    pkgs.networkmanager-strongswan
  ];

  networking.firewall.allowedTCPPorts = [22 80 443];

  users.extraGroups.networkmanager.members = [user.login];

  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";
}
