{pkgs, ...}: {
  imports = [
    ../modules/core/base
    ../modules/core/server
  ];

  boot.loader.systemd-boot.enable = true;

  networking = {
    networkmanager.enable = false;
    firewall = {
      rejectPackets = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [
    htop
    tmux
    ncdu
    lsof
    iotop
  ];
}
