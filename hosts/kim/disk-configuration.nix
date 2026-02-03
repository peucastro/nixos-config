{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/data" = {
      device = "/dev/disk/by-uuid/99a58cf6-98ef-4107-b981-3b78bb35cbb6";
      fsType = "ext4";
      options = ["defaults" "nofail"];
    };
    "/data/personal" = {
      device = "/dev/disk/by-uuid/eff1f60a-bf9f-4fca-84c2-1362c8e43706";
      fsType = "ext4";
      options = ["defaults" "nofail"];
      depends = ["/data"];
    };

    "/mnt/backups" = {
      device = "/dev/disk/by-uuid/11ef621f-4a20-4dfc-96e8-a6927941d73a";
      fsType = "ext4";
      options = ["defaults" "nofail"];
    };
    "/mnt/backups/restic" = {
      device = "/mnt/backups/restic";
      fsType = "none";
      options = ["bind" "rbind" "create=dir"];
      depends = ["/mnt/backups"];
    };
    "/mnt/backups/postgres" = {
      device = "/mnt/backups/postgres";
      fsType = "none";
      options = ["bind" "rbind" "create=dir"];
      depends = ["/mnt/backups"];
    };
  };
}
