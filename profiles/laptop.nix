{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../secrets/default.nix
    ../secrets/laptop.nix
    ../modules/core/base
    ../modules/core/desktop
    ../modules/core/gaming
    ../modules/core/hardware
    ../modules/core/services/snapper.nix
    ../modules/core/virtualisation
  ];

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-strongswan
      ];
      wifi.powersave = true;
    };
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    firewall.allowedTCPPorts = [22 80 443];
  };

  users.extraGroups.networkmanager.members = [user.login];

  services = {
    strongswan.enable = true;
    tailscale.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  environment.etc."strongswan.conf".text = "";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # Filesystem
    btrfs-progs
    snapper
    veracrypt

    # Utilities
    unzip
    zip
    ffmpeg
    man-pages
    comma

    # Monitoring & power
    htop
    powertop
    acpi

    # Tools from base modules
    nh
  ];
}
