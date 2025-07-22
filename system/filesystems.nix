{
  # Mount NVMe to /home
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2c267b4d-98fe-4496-a02c-c32b1d19dfd9";
    fsType = "btrfs";
    options = [ "compress=lzo" ];
  };

  # Redefine / here so we can turn on compression
  fileSystems."/" = {
    options = [ "compress=lzo" ];
  };

  fileSystems."/backups" = {
    device = "/dev/disk/by-uuid/2da4ca3c-5cfa-4759-8d64-de5f553e16e7";
    fsType = "ext4";
    options = [
      "noatime"
      "defaults"
    ];
  };
}
