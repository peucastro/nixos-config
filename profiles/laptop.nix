{
  pkgs,
  user,
  secrets,
  ...
}: {
  imports = [
    ../modules/core/base
    ../modules/core/desktop
    ../modules/core/gaming
    ../modules/core/hardware
    ../modules/core/services/services.nix
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

  age.secrets = {
    id_ed25519 = {
      file = "${secrets}/id_ed25519.age";
      path = "/home/peu/.ssh/id_ed25519";
      symlink = true;
      mode = "0400";
      owner = "peu";
      group = "users";
    };
  };

  environment.systemPackages = with pkgs; [
    # Filesystem
    btrfs-progs
    snapper

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
