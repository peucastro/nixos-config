{
  lib,
  host,
  ...
}: {
  networking = {
    hostName = host;
    nameservers = lib.mkDefault ["1.1.1.1" "1.0.0.1"];
    firewall.enable = true;
  };
}
