{...}: {
  imports = [../modules/core];

  networking = {
    firewall = {
      rejectPackets = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  services.xserver.enable = false;
}
