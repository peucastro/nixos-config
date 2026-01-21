{host, ...}: {
  networking = {
    hostName = "${host}";
    nameservers = ["1.1.1.1" "1.0.0.1"];
    firewall.enable = true;
  };
}
