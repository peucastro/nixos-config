{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../modules/core/base
    ../modules/core/desktop
    ../modules/core/gaming
    ../modules/core/hardware
    ../modules/core/services
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

  time.timeZone = "Europe/Lisbon";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
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
    };
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    firewall.allowedTCPPorts = [22 80 443];
  };

  users.extraGroups.networkmanager.members = [user.login];

  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";
  services.tailscale.enable = true;

  # Workstation packages
  environment.systemPackages = with pkgs; [
    # Filesystem
    btrfs-progs
    snapper
    snapper-gui
    veracrypt
    gparted

    # Networking
    wavemon

    # Utilities
    unzip
    zip
    ffmpeg
    openssl
    man-pages
    android-tools
    comma

    # Monitoring
    htop
  ];
}
